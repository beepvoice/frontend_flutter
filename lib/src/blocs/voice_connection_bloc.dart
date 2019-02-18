import "package:rxdart/rxdart.dart";

import "../services/peer_manager.dart";
import "../../settings.dart";

class VoiceConnection {
  final PeerManager _peerManager = PeerManager(globalUserId, "2");
  final _bottomBarBus = PublishSubject<Map<String, dynamic>>();

  BottomBarBus() {
    _bottomBarBus.listen((data) => print(data));
  }

  Observable<Map<String, dynamic>> get bus => _bottomBarBus.stream;

  publish(Map<String, dynamic> message) async {
    _bottomBarBus.sink.add(message);
  }

  dispose() {
    _bottomBarBus.close();
  }
}

// global instance for access throughout the app
final voiceConnection = VoiceConnection();
