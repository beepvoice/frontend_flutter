import "dart:async";
import "dart:convert";
import "package:eventsource/eventsource.dart";
import "package:flutter_webrtc/webrtc.dart";
import "package:http/http.dart" as http;
import "../../settings.dart";

// Available utility enums
enum SignalingResponse { SUCCESSFULL, NO_DEVICE, NO_DATA }
enum SignalType { CANDIDATE, OFFER, ANSWER }

// Callback definitions
typedef void OnMessageCallback(Map<String, dynamic> data);

class PeerConnectionFactory {
  final String _localUserId;
  final String _localDeviceId;

  EventSource _signalingServer;
  MediaStream _stream;

  //Callbacks
  OnMessageCallback onMessageCallback;

  final Map<String, dynamic> _iceServers = {
    "iceServers": [
      {"url": "stun:stun.l.google.com:19302"}
    ]
  };

  final Map<String, dynamic> _config = {
    "mandatory": {},
    "optional": [
      {"DtlsSrtpKeyAgreement": true}
    ]
  };

  final Map<String, dynamic> _constraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": false,
    },
    "optional": []
  };

  PeerConnectionFactory(this._localUserId, this._localDeviceId, this._stream,
      this.onMessageCallback);

  // initialize() method sets up a subscription to the eventsource and
  // attaches a callback to it
  initialize() async {
    _signalingServer = await EventSource.connect(
        "$baseUrlSignaling/subscribe/$_localUserId/device/$_localDeviceId");

    _signalingServer.listen((event) {
      // Don't process empty colons
      if (event.data == null) return;

      print("signalling/ ${event.data}");
      onMessageCallback(jsonDecode(event.data));
    });
  }

  newPeerConnection(String remoteUserId, String remoteDeviceId) async {
    RTCPeerConnection connection =
        await createPeerConnection(_iceServers, _config);
    connection.addStream(_stream);

    // Send candidates to remote
    connection.onIceCandidate =
        (candidate) => _sendToRemote(remoteUserId, remoteDeviceId, {
              "fromUser": this._localUserId,
              "fromDevice": this._localDeviceId,
              "type": SignalType.CANDIDATE.index,
              "sdpMLineIndex": candidate.sdpMlineIndex,
              "sdpMid": candidate.sdpMid,
              "candidate": candidate.candidate
            });

    // Create and send the offer
    RTCSessionDescription session = await connection.createOffer(_constraints);
    connection.setLocalDescription(session);
    await _sendToRemote(remoteUserId, remoteDeviceId, {
      "fromUser": this._localUserId,
      "fromDevice": this._localDeviceId,
      "type": SignalType.OFFER.index,
      "sdp": session.sdp,
      "session": session.type,
    });

    return connection;
    // NEED TO WAIT FOR ANSWER BEFORE CONNECTION IS ESTABLISHED
  }

  leavePeerConnection(RTCPeerConnection connection) {
    connection.removeStream(_stream);
    connection.close();
  }

  sendAnswer(RTCPeerConnection connection, String remoteUserId,
      String remoteDeviceId) async {
    RTCSessionDescription session = await connection.createAnswer(_constraints);
    connection.setLocalDescription(session);
    _sendToRemote(remoteUserId, remoteDeviceId, {
      "fromUser": this._localUserId,
      "fromDevice": this._localDeviceId,
      "type": SignalType.ANSWER.index,
      "sdp": session.sdp,
      "session": session.type,
    });
  }

  Future<SignalingResponse> _sendToRemote(String remoteUserId,
      String remoteDeviceId, Map<String, dynamic> data) async {
    var response = await http.post(
        "$baseUrlSignaling/user/$remoteUserId/device/$remoteDeviceId",
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"data": data}));

    switch (response.statusCode) {
      case 200:
        return SignalingResponse.SUCCESSFULL;
      case 400:
        return SignalingResponse.NO_DATA;
      case 404:
        return SignalingResponse.NO_DEVICE;
      default:
        return SignalingResponse.NO_DEVICE;
    }
  }
}
