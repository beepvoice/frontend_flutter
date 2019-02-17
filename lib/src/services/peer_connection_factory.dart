import "dart:async";
import "dart:convert";
import "package:eventsource/eventsource.dart";
import "package:flutter_webrtc/webrtc.dart";
import "package:http/http.dart" as http;

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
      this.onMessageCallback) {
    _initialize();
  }

  // initialize() method sets up a subscription to the eventsource and
  // attaches a callback to it
  _initialize() async {
    _signalingServer = await EventSource.connect(
        "localhost:10201/subscribe/$_localUserId/device/$_localDeviceId");
    _signalingServer.listen((event) {
      print(event.data);
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
              "type": SignalType.CANDIDATE,
              "sdpMLineIndex": candidate.sdpMlineIndex,
              "sdpMid": candidate.sdpMid,
              "candidate": candidate.candidate
            });

    // Create and send the offer
    RTCSessionDescription session = await connection.createOffer(_constraints);
    connection.setLocalDescription(session);
    _sendToRemote(remoteUserId, remoteDeviceId, {
      "fromUser": this._localUserId,
      "fromDevice": this._localDeviceId,
      "type": SignalType.OFFER,
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
      "type": SignalType.ANSWER,
      "sdp": session.sdp,
      "session": session.type,
    });
  }

  Future<SignalingResponse> _sendToRemote(String remoteUserId,
      String remoteDeviceId, Map<String, dynamic> data) async {
    var response = await http.post(
        "localhost:10201/user/$remoteUserId/device/$remoteDeviceId",
        body: {"data": jsonEncode(data)});
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