//
//  PeerManager.swift
//  Runner
//
//  Created by Sudharshan on 3/29/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import WebRTC
import Just
import Starscream
import PercentEncoder

public enum RTCWrapperState {
    case disconnected
    case connected
    case connecting
}

class PeerManager: NSObject {
    //****************************************************************************************************
    // GLOBAL CLASS ATTRIBUTES
    //****************************************************************************************************
    
    // State
    var state: RTCWrapperState = .disconnected
    var activeConversation: String?
    var authToken: String?
    
    // Required interfaces
    var connectionFactory: RTCPeerConnectionFactory?
    var socket: WebSocket?
    
    // WebRTC
    var peerConnection: RTCPeerConnection?
    var remoteIceCandidates: [RTCIceCandidate] = []
    
    // Configuration
    let iceServers: [RTCIceServer] = [RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"])]
    let connectionConstraint = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: ["DtlsSrtpKeyAgreement": "true"])
    let channelConstraint = RTCMediaConstraints(mandatoryConstraints: ["OfferToReceiveAudio" : "true"], optionalConstraints: nil)
    
    // Streams
    var localMediaStream: RTCMediaStream!
    var localAudioTrack: RTCAudioTrack!
    var remoteAudioTrack: RTCAudioTrack!
    
    //****************************************************************************************************
    // START OF PUB FUNCTIONS AND INIT
    //****************************************************************************************************
    
    public override init() {
        super.init()
        
        // Initialize peer factory
        RTCPeerConnectionFactory.initialize()
        self.connectionFactory = RTCPeerConnectionFactory()
    }
    
    // MUST CALL THIS BEFORE STUFF WORKS
    public func initializeToken(authToken: String) {
        self.authToken = authToken
    }
    
    public func join(conversationId: String) {
        self.activeConversation = conversationId
        
        // Setup socket and peerconnection if it doesn't exist
        if (self.socket == nil) {
            var request = URLRequest(url: URL(string: "ws://localhost:8080/")!)
            request.setValue("Bearer \(self.authToken ?? "0")", forHTTPHeaderField: "Authorization")
            
            self.socket = WebSocket(request: request)
            self.socket?.delegate = self
            self.socket?.connect()
        } else if(self.peerConnection == nil) {
            self.connect()
        }
        
        // Configure SFU conversation Id
        Just.post("http://localhost/join/\(conversationId)",
            headers: ["Authorization": "Bearer \(self.authToken ?? "0")"])
    }
    
    public func exit() {
        activeConversation = nil
        self.disconnect()
        self.socket?.disconnect()
    }
    
    public func get() -> String? {
        return activeConversation
    }
}

//****************************************************************************************************
// START OF PRIVATE FUNCTIONS
//****************************************************************************************************

private extension PeerManager {
    func connect() {
        // Create peerconnection
        let configuration = RTCConfiguration()
        configuration.iceServers = self.iceServers;
        let peerConnection = self.connectionFactory?.peerConnection(with: configuration, constraints: self.connectionConstraint, delegate: self)
        
        // Add localstream to peerconnection
        self.state = .connecting
        let localStream = self.localStream()
        peerConnection?.add(localStream)
        
        // Store peerconnection
        self.peerConnection = peerConnection
        self.createOffer()
    }
    
    func disconnect() {
        if let peerConnection = self.peerConnection {
            peerConnection.close()
            if let stream = peerConnection.localStreams.first {
                peerConnection.remove(stream)
            }
            
            // Reset state
            self.peerConnection = nil
            self.state = .disconnected
        }
    }
    
    func createOffer() {
        if let peerConnection = self.peerConnection {
            
            peerConnection.offer(for: self.channelConstraint, completionHandler: { [weak self]  (sdp, error) in
                // Exit if this object doesn't exist anymore cause it is a weak link
                guard let this = self else { return }
                
                if let error = error {
                    print(error)
                } else {
                    // Use the sdp generated
                    guard let sdp = sdp else{
                        return
                    }

                    this.peerConnection?.setLocalDescription(sdp, completionHandler: {[weak self] (error) in
                        guard let _ = self, let error = error else { return }
                        print(error)
                    })
                    
                    // Post it to the server
                    this.socket?.write(string: "offer::\(sdp.sdp)")
                }
            })
        }
    }
    
    func createAnswerForOffer(remoteSdp: String) {
        if let peerConnection = self.peerConnection {
            let sessionDescription = RTCSessionDescription.init(type: .offer, sdp: remoteSdp)
            peerConnection.setRemoteDescription(sessionDescription, completionHandler: { [weak self] (error) in
                // Exit if this object doesn't exist anymore cause it is a weak link
                guard let this = self else { return }
                
                if let error = error {
                    // Throw an error
                    print(error)
                } else {
                    // Add ice-candidates after setting remote description
                    for iceCandidate in this.remoteIceCandidates {
                        peerConnection.add(iceCandidate)
                    }
                    this.remoteIceCandidates = []
                    
                    // create answer
                    peerConnection.answer(for: this.channelConstraint, completionHandler:
                        { (sdp, error) in
                            if let error = error {
                                // Throw an error
                                print(error)
                            } else {
                                guard let sdp = sdp else{
                                    return
                                }
                                // add generated local sdp
                                peerConnection.setLocalDescription(sdp, completionHandler: {[weak self] (error) in
                                    guard let _ = self, let error = error else { return }
                                    print(error)
                                })
                                
                                // Send the localsdp to the server
                                this.socket?.write(string: "answer::\(sdp.sdp)")
                                this.state = .connected
                            }
                    })
                }
            })
        }
    }
    
    func handleAnswer(remoteSdp: String) {
        if let peerConnection = self.peerConnection {
            let sessionDescription = RTCSessionDescription.init(type: .answer, sdp: remoteSdp)
            
            peerConnection.setRemoteDescription(sessionDescription, completionHandler: { [weak self] (error) in
                // Exit if this object doesn't exist anymore cause it is a weak link
                guard let this = self else { return }
                
                if let error = error {
                    // Throw an error
                    print(error)
                } else {
                    // Add ice-candidates after setting remote description
                    for iceCandidate in this.remoteIceCandidates {
                        peerConnection.add(iceCandidate)
                    }
                    this.remoteIceCandidates = []
                    this.state = .connected
                }
            })
        }
    }

    
    func addIceCandidate(iceCandidate: RTCIceCandidate) {
        // Set ice candidate after setting remote description
        if self.peerConnection?.remoteDescription != nil {
            self.peerConnection?.add(iceCandidate)
        } else {
            self.remoteIceCandidates.append(iceCandidate)
        }
    }
    
    // Utility function for creating a localStream
    func localStream() -> RTCMediaStream {
        let factory = self.connectionFactory!
        let localStream = factory.mediaStream(withStreamId: "RTCmS")
        
        let audioTrack = factory.audioTrack(withTrackId: "RTCaS0")
        localStream.addAudioTrack(audioTrack)
        
        return localStream
    }
}

//****************************************************************************************************
// START OF WEBRTC DELEGATIONS
//****************************************************************************************************
extension PeerManager: RTCPeerConnectionDelegate {
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        print("adding new stream from remote")
        self.remoteAudioTrack = stream.audioTracks[0]
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        let candidateString = "\(candidate.sdp)::\(candidate.sdpMLineIndex)::\(candidate.sdpMid ?? "")"
        self.socket?.write(string: "ice::\(candidateString)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        
    }
}

//****************************************************************************************************
// START OF WEBSOCKET DELEGATIONS
//****************************************************************************************************
extension PeerManager: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        return
    }
    
    // FORMAT OF MESSAGE <message-type>::<message>
    // message-type: (offer, ice)
    // message:
    //  offer: <remoteSdp, String>
    //  ice: <sdp, String>::<sdpMLineIndex, String>::<sdpMid, String>
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let dataArr = text.components(separatedBy: "::")
        
        if(dataArr[0] == "offer") {
            // Handle offer
            
            // Check dataArr size of 2
            if dataArr.count != 2 {
                // Incorrect data format error
                return
            }
            
            self.createAnswerForOffer(remoteSdp: dataArr[1])
        } else if (dataArr[0] == "answer") {
            // Handle answer
            
            // Check dataArr size of 2
            if dataArr.count != 2 {
                // Incorrect data format error
                return
            }
            
            self.handleAnswer(remoteSdp: dataArr[1])
        } else if(dataArr[0] == "ice") {
            // Handle ice
            
            // Check dataArr size of 4
            if dataArr.count != 4 {
                // Incorrect data format error
                return
            }
            
            guard let sdpMLineIndex = Int32(dataArr[2]) else {
                // Invalid sdpMLineIndex error
                return
            }
            
            let iceCandidate = RTCIceCandidate(sdp: dataArr[1], sdpMLineIndex: sdpMLineIndex, sdpMid: dataArr[3])
            self.addIceCandidate(iceCandidate: iceCandidate)
        } else {
            // Invalid format error
            return
        }
    }
}
