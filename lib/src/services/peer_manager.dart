import "package:flutter_webrtc/webrtc.dart";
import "peer_connection_factory.dart";

import "../resources/signaling_api_provider.dart";

class PeerManager {
  String _selfUserId;
  String _selfDeviceId;

  PeerConnectionFactory _peerConnectionFactory;
  MediaStream _localStream;
  SignalingApiProvider signalingApiProvider = SignalingApiProvider();

  List<MediaStream> _currentStreams = [];
  Map<String, RTCPeerConnection> _currentConnections = {};

  PeerManager(this._selfUserId, this._selfDeviceId);

  List<MediaStream> get streams => _currentStreams;

  initialize() async {
    final Map<String, dynamic> mediaConstraints = {
      "audio": true,
      "video": false
    };

    _localStream = await navigator.getUserMedia(mediaConstraints);
    _peerConnectionFactory = PeerConnectionFactory(
        _selfUserId, _selfDeviceId, _localStream, _signalEventHandler);
    await _peerConnectionFactory.initialize();
  }

  addPeer(String userId) async {
    List<dynamic> deviceIds = await signalingApiProvider.getUserDevices(userId);

    deviceIds.forEach((deviceId) async {
      RTCPeerConnection connection =
          await _peerConnectionFactory.newPeerConnection(userId, deviceId);

      // Handle streams being added and removed remotely
      connection.onAddStream = (stream) => _currentStreams.add(stream);
      connection.onRemoveStream =
          (stream) => _currentStreams.removeWhere((it) => stream.id == it.id);

      // Add peer connection to the map
      _currentConnections.addAll({"$userId-$deviceId": connection});
    });
  }

  leaveAll() async {
    // DO WE NEED TO CLOSE THE REMOTE STREAMS???
    _currentConnections.forEach((key, value) {
      _peerConnectionFactory.leavePeerConnection(value);
      _currentConnections[key] = null;
    });

    _currentStreams.forEach((stream) {
      stream.dispose();
    });

    _currentStreams = [];
  }

  _signalEventHandler(Map<String, dynamic> data) async {
    switch (SignalType.values[data["type"]]) {
      case SignalType.CANDIDATE:
        String userId = data["fromUser"];
        String deviceId = data["fromDevice"];
        RTCPeerConnection connection = _currentConnections["$userId-$deviceId"];

        if (connection != null) {
          RTCIceCandidate candidate = RTCIceCandidate(
              data["candidate"], data["sdpMid"], data["sdpMLineIndex"]);
          connection.addCandidate(candidate);
        }
        break;

      case SignalType.OFFER:
        String userId = data["fromUser"];
        String deviceId = data["fromDevice"];

        RTCPeerConnection connection =
            await _peerConnectionFactory.newPeerConnection(userId, deviceId);

        // Handle streams being added and removed remotely
        connection.onAddStream = (stream) => _currentStreams.add(stream);
        connection.onRemoveStream =
            (stream) => _currentStreams.removeWhere((it) => stream.id == it.id);

        _currentConnections["$userId-$deviceId"] = connection;

        connection.setRemoteDescription(
            RTCSessionDescription(data["sdp"], data["sessionType"]));
        _peerConnectionFactory.sendAnswer(connection, userId, deviceId);
        break;

      case SignalType.ANSWER:
        String userId = data["fromUser"];
        String deviceId = data["fromDevice"];

        RTCPeerConnection connection = _currentConnections["$userId-$deviceId"];
        if (connection != null) {
          connection.setRemoteDescription(
              RTCSessionDescription(data["sdp"], data["sessionType"]));
          break;
        }
    }
  }
}
