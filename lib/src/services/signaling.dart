import 'dart:async';
import 'package:eventsource/eventsource.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:http/http.dart' as http;

enum SignalingResponse { SUCCESSFULL, NO_DEVICE, NO_DATA }

class PeerConnectionFactory {
  final String _selfUserId;
  final String _selfDeviceId;
  EventSource _signalingServer;

  // could be const
  Map<String, dynamic> _iceServers = {
    "iceServers": [
      {"url": "stun:stun.l.google.com:19302"}
    ]
  };

  // could be const
  final Map<String, dynamic> _config = {
    "mandatory": {},
    "optional": [
      {"DtlsSrtpKeyAgreement": true}
    ]
  };

  // could be const
  final Map<String, dynamic> _constraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": false,
    },
    "optional": []
  };

  PeerConnectionFactory(this._selfUserId, this._selfDeviceId);

  // initialize() method sets up a subscription to the eventsource and
  // attaches a callback to it
  initialize() async {
    _signalingServer = await EventSource.connect(
        "localhost:10201/subscribe/$_selfUserId/device/$_selfDeviceId");
    _signalingServer.listen((event) => print(event.data));
  }

  Future<RTCPeerConnection> newPeerConnection(
      String remoteId, String remoteDevice, MediaStream stream) async {
    RTCPeerConnection connection =
        await createPeerConnection(_iceServers, _config);
    connection.addStream(stream);

    // Send candidates to remote (NOT_IMPLEMENTED TO SEND)
    connection.onIceCandidate =
        (candidate) => _sendToRemote(remoteId, remoteDevice);

    // Create and send the offer
    RTCSessionDescription session = await connection.createOffer(_constraints);
    connection.setLocalDescription(session);
    _sendToRemote(remoteId, remoteDevice);

    return connection;
    // NEED TO WAIT FOR ANSWER BEFORE CONNECTION IS ESTABLISHED
  }

  peerConnectionAnswer(RTCPeerConnection connection, String remoteId,
      String remoteDevice) async {
    RTCSessionDescription session = await connection.createAnswer(_constraints);
    connection.setLocalDescription(session);
    _sendToRemote(remoteId, remoteDevice);
  }

  Future<SignalingResponse> _sendToRemote(
      String remoteId, String remoteDevice) async {
    var response =
        await http.post("localhost:10201/user/$remoteId/device/$remoteDevice");
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
