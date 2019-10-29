package com.example.frontend_flutter

import android.content.Context
import org.webrtc.PeerConnection.IceServer
import org.webrtc.PeerConnection.RTCConfiguration
import org.webrtc.PeerConnection.PeerConnectionState
import com.neovisionaries.ws.client.*
import org.webrtc.*
import java.net.URL
import org.webrtc.SessionDescription
import java.net.HttpURLConnection


class PeerManager(applicationContext: Context) {
    // State
    private var state: PeerConnectionState = PeerConnectionState.DISCONNECTED
    private var activeConversation: String? = null
    private var authToken: String? = null

    // Required interfaces
    private var connectionFactory: PeerConnectionFactory
    private var sockConnect: Boolean = false
    private var socket: WebSocket? = null

    // WebRTC
    private var peerConnection: PeerConnection? = null
    private var remoteIceCandidates = ArrayList<IceCandidate>()

    // Configuration
    private var iceServers: List<IceServer> = listOf(IceServer.builder("stun:stun.l.google.com:19302").createIceServer())
    private var channelConstraint = MediaConstraints().apply { mandatory.add(MediaConstraints.KeyValuePair("OfferToReceiveAudio", "true")) }

    // Streams
    private lateinit var remoteAudioTrack: AudioTrack


    //****************************************************************************************************
    // START OF PUB FUNCTIONS AND INIT
    //****************************************************************************************************

    init {
        PeerConnectionFactory.initialize(PeerConnectionFactory.InitializationOptions.builder(applicationContext).createInitializationOptions())
        connectionFactory = PeerConnectionFactory.builder().createPeerConnectionFactory()
    }

    // MUST CALL THIS BEFORE STUFF WORKS
    fun initializeToken(authToken: String) {
        this.authToken = authToken
    }

    fun join(conversationId: String) {
        activeConversation = conversationId

        // Setup socket and peerConnection if it doesn't exist
        if (socket == null) {
            socket = WebSocketFactory()
                    .createSocket(URL("wss://staging.beepvoice.app/webrtc/connect"))
                    .addHeader("Authorization", "Bearer ${authToken ?: "0"}")
                    .addHeader("Host", "staging.beepvoice.app")
                    .addListener(CustomWSAdapter())
                    .connect()


            // TODO: Test if disabling SSL cert verification is necessary
            //s.disableSSLCertValidation = true
        }

        // Configure SFU conversation Id
        URL("https://staging.beepvoice.app/webrtc/join/${conversationId}")
                .openConnection()
                .run {
                    // Cast to a HTTP connection
                    this as HttpURLConnection
                }.apply {
                    // Configure request and connect to the URL
                    requestMethod = "POST"
                    setRequestProperty("Authorization", "Bearer ${authToken ?: "0"}")
                    connect()
                }

        // Connect the PeerConnection
        connect()
    }

    fun exit() {
        activeConversation = null
        disconnect()
    }

    fun get(): String? {
        return activeConversation
    }


    //****************************************************************************************************
    // START OF PRIVATE FUNCTIONS
    //****************************************************************************************************
    private fun connect() {
        // Create peerConnection
        val configuration = RTCConfiguration(iceServers).apply { enableDtlsSrtp = true }
        peerConnection = connectionFactory.createPeerConnection(configuration, CustomPeerConnectionObserver())

        // Add localStream to peerConnection
        state = PeerConnectionState.CONNECTING
        peerConnection?.addStream(localStream())

        // Store peerConnection
        print("CONNECTING")
        createOffer()
    }

    private fun disconnect() {
        // Executes if peerConnection is not null
        peerConnection?.let {
            it.close()
            it.dispose()

            socket?.disconnect()
            socket?.clearListeners()

            while(sockConnect) {}

            peerConnection = null
            socket = null
            state = PeerConnectionState.DISCONNECTED
        }
    }

    private fun createOffer() {
        peerConnection?.createOffer(object : SdpObserver {
            override fun onCreateSuccess(sdp: SessionDescription) {
                peerConnection?.setLocalDescription(PrintSdpObserverError(), sdp)

                while (!sockConnect) {}

                socket?.sendText("offer::${sdp}")
            }

            override fun onCreateFailure(error: String) { print(error) }
            override fun onSetFailure(error: String) { print(error) }
            override fun onSetSuccess() {}
        }, channelConstraint)
    }

    private fun createAnswerForOffer(remoteSdp: String) {
        // Executes if peerConnection is not null
        peerConnection?.let {
            val sessionDescription = SessionDescription(SessionDescription.Type.OFFER, remoteSdp)

            it.setRemoteDescription(object: SdpObserver {
                override fun onSetSuccess() {
                    // Add ice-candidates after setting remote description
                    for (iceCandidate in remoteIceCandidates) {
                        it.addIceCandidate(iceCandidate)
                    }
                    remoteIceCandidates.clear()

                    // Create answer
                    it.createAnswer(object: SdpObserver {
                        override fun onCreateSuccess(sdp: SessionDescription) {
                            it.setLocalDescription(PrintSdpObserverError(), sdp)

                            // Send the localsdp to the server
                            socket?.sendText("answer::${sdp}")
                            state = PeerConnectionState.CONNECTED
                        }
                        override fun onCreateFailure(error: String) { print(error) }
                        override fun onSetFailure(error: String) { print(error) }
                        override fun onSetSuccess() {}
                    }, channelConstraint)
                }

                override fun onSetFailure(error: String) { print(error) }
                override fun onCreateFailure(error: String) { print(error) }
                override fun onCreateSuccess(sdp: SessionDescription) {}
            }, sessionDescription)
        }
    }

    private fun handleAnswer(remoteSdp: String) {
        // Executes if peerConnection is not null
        peerConnection?.let {
            val sessionDescription = SessionDescription(SessionDescription.Type.ANSWER, remoteSdp)

            it.setRemoteDescription(object: SdpObserver {
                override fun onSetSuccess() {
                    // Add ice-candidates after setting remote description
                    for (iceCandidate in remoteIceCandidates) {
                        it.addIceCandidate(iceCandidate)
                    }
                    remoteIceCandidates.clear()
                    state = PeerConnectionState.CONNECTED
                }

                override fun onCreateFailure(error: String) { print(error) }
                override fun onSetFailure(error: String) { print(error) }
                override fun onCreateSuccess(sdp: SessionDescription) {}
            }, sessionDescription)
        }
    }

    private fun addIceCandidate(iceCandidate: IceCandidate) {
        // Set ice candidate after setting remote description
        if (peerConnection?.remoteDescription != null) {
            peerConnection?.addIceCandidate(iceCandidate)
        } else {
            remoteIceCandidates.add(iceCandidate)
        }
    }

    // Utility function for creating a localStream
    private fun localStream(): MediaStream {
        val localStream = connectionFactory.createLocalMediaStream("RTCmS")
        val audioTrack = connectionFactory.createAudioTrack("RTCaS0", connectionFactory.createAudioSource(MediaConstraints()))
        localStream.addTrack(audioTrack)

        return localStream
    }


    //****************************************************************************************************
    // PeerConnection.Observer implementation
    //****************************************************************************************************
    inner class CustomPeerConnectionObserver: PeerConnection.Observer {
        override fun onSignalingChange(signalingState: PeerConnection.SignalingState) {}
        override fun onIceConnectionChange(iceConnectionState: PeerConnection.IceConnectionState) {}
        override fun onIceConnectionReceivingChange(b: Boolean) {}
        override fun onRemoveStream(mediaStream: MediaStream) {}
        override fun onDataChannel(dataChannel: DataChannel) {}
        override fun onRenegotiationNeeded() {}
        override fun onIceCandidatesRemoved(iceCandidates: Array<IceCandidate>) {}
        override fun onIceGatheringChange(iceGatheringState: PeerConnection.IceGatheringState) {}
        override fun onAddTrack(rtpReceiver: RtpReceiver, mediaStreams: Array<MediaStream>) {}

        override fun onIceCandidate(iceCandidate: IceCandidate) {
            // TODO: Check if this is necessary
            socket?.sendText("ice::${iceCandidate}")
        }

        override fun onAddStream(stream: MediaStream) {
            print("adding new stream from remote")
            remoteAudioTrack = stream.audioTracks[0]
        }
    }


    //****************************************************************************************************
    // Custom WebSocket listener for processing messages
    //****************************************************************************************************
    inner class CustomWSAdapter: WebSocketAdapter() {

        override fun onError(websocket: WebSocket?, cause: WebSocketException?) {
            // TODO: Check if cause.getError() produces better error messages
            print("WebSocket error: $cause")
        }

        override fun onConnected(websocket: WebSocket?, headers: MutableMap<String, MutableList<String>>?) {
            print("WebSocket is connected")
            sockConnect = true
        }

        override fun onDisconnected(websocket: WebSocket?, serverCloseFrame: WebSocketFrame?, clientCloseFrame: WebSocketFrame?, closedByServer: Boolean) {
            print("WebSocket is disconnected")
            sockConnect = false
        }

        // FORMAT OF MESSAGE <message-type>::<message>
        // message-type: (offer, ice)
        // message:
        //  offer: <remoteSdp, String>
        //  ice: <sdp, String>::<sdpMLineIndex, String>::<sdpMid, String>
        override fun onTextMessage(websocket: WebSocket?, text: String?) {
            val dataArr: List<String>? = text?.split("::")
            print(text)

            when (dataArr?.get(0)) {
                "offer" -> {
                    print("OFFER:\n${dataArr[1]}")
                    // Check dataArr size of 2
                    if (dataArr.count() != 2) {
                        // Incorrect data format error
                        return
                    }
                    this@PeerManager.createAnswerForOffer(dataArr[1])
                }
                "answer" -> {
                    // Handle answer
                    print("ANSWER:\n${dataArr[1]}")
                    // Check dataArr size of 2
                    if (dataArr.count() != 2) {
                        // Incorrect data format error
                        return
                    }
                    this@PeerManager.handleAnswer(dataArr[1])
                }
                "ice" -> {
                    // Handle ice
                    print("ICE:\n${dataArr[1]}")
                    // Check dataArr size of 2
                    if (dataArr.count() != 2) {
                        // Incorrect data format error
                        return
                    }
                    this@PeerManager.addIceCandidate(IceCandidate(null, 0, dataArr[1]))
                }
            }
        }
    }


    //****************************************************************************************************
    // Simple SdpObserver implementation that prints errors only
    //****************************************************************************************************
    class PrintSdpObserverError: SdpObserver {
        /** Called on error of Create{Offer,Answer}().  */
        override fun onCreateFailure(error: String) { print(error) }
        /** Called on error of Set{Local,Remote}Description().  */
        override fun onSetFailure(error: String) { print(error) }
        /** Called on success of Create{Offer,Answer}().  */
        override fun onCreateSuccess(sdp: SessionDescription) {}
        /** Called on success of Set{Local,Remote}Description().  */
        override fun onSetSuccess() {}
    }
}
