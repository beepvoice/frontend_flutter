import "package:flutter_webrtc/webrtc.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import "dart:async";
import "peer_connection_factory.dart";
import "../../settings.dart";

class PeerManager {
  String _selfUserId;
  String _selfDeviceId;

  PeerConnectionFactory _peerConnectionFactory;
  MediaStream _localStream;

  List<MediaStream> _currentStreams;
  Map<String, RTCPeerConnection> _currentConnections;

  PeerManager(this._selfUserId, this._selfDeviceId) {
    _initialize();
  }

  _initialize() async {
    final Map<String, dynamic> mediaConstraints = {
      "audio": true,
      "video": false
    };

    _localStream = await navigator.getUserMedia(mediaConstraints);
    _peerConnectionFactory = PeerConnectionFactory(
        _selfUserId, _selfDeviceId, _localStream, _signalEventHandler);
  }

  addPeer(String userId) async {
    var response = await http.get("$baseUrlSignaling/user/$userId/devices");
    List<dynamic> deviceIds = jsonDecode(response.body);

    deviceIds.forEach((deviceId) async {
      RTCPeerConnection connection =
          await _peerConnectionFactory.newPeerConnection(userId, deviceId);

      // Handle streams being added and removed remotely
      connection.onAddStream = (stream) => _currentStreams.add(stream);
      connection.onRemoveStream =
          (stream) => _currentStreams.removeWhere((it) => stream.id == it.id);

      // Add peer connection to the map
      _currentConnections["$userId-$deviceId"] = connection;
    });
  }

  leaveAll() async {
    // DO WE NEED TO CLOSE THE REMOTE STREAMS???
    _currentConnections.forEach((key, value) {
      _peerConnectionFactory.leavePeerConnection(value);
      _currentConnections[key] = null;
    });
  }

  _signalEventHandler(Map<String, dynamic> data) async {
    switch (data["type"]) {
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
