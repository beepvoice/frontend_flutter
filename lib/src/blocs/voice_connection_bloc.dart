import "package:rxdart/rxdart.dart";
import "package:flutter_webrtc/webrtc.dart";

import "../resources/conversation_api_provider.dart";
import "../models/user_model.dart";
import "../services/peer_manager.dart";
import "../../settings.dart";

class VoiceConnection {
  final PeerManager _peerManager = PeerManager(globalUserId, "2");
  final _conversationApiProvider = ConversationApiProvider();
  final _bottomBarBus = PublishSubject<Map<String, dynamic>>();

  VoiceConnection() {
    _bottomBarBus.listen((data) => print(data));
    _peerManager.initialize();
  }

  Observable<Map<String, dynamic>> get bus => _bottomBarBus.stream;

  publish(Map<String, dynamic> message) async {
    _bottomBarBus.sink.add(message);
  }

  join(String conversationId) async {
    List<User> users =
        await _conversationApiProvider.fetchConversationMembers(conversationId);

    // Add the users to the streams
    users.forEach((user) {
      _peerManager.addPeer(user.id);
    });

    List<MediaStream> connectedStreams = _peerManager.streams;
  }

  dispose() {
    _bottomBarBus.close();
  }
}

// global instance for access throughout the app
final voiceConnection = VoiceConnection();
