import "package:rxdart/rxdart.dart";
import "../services/conversation_manager.dart";

class BottomBusBloc {
  final _bottomBarBus = PublishSubject<Map<String, String>>();
  Map<String, String> _currentState;
  final conversationManager = ConversationManager();

  BottomBusBloc() {
    _bottomBarBus.listen((data) => print(data));
  }

  Observable<Map<String, String>> get bus => _bottomBarBus.stream;
  Map<String, String> get currentState => _currentState;

  publish(Map<String, String> message) async {
    _bottomBarBus.sink.add(message);
  }

  void getCurrentState() async {
    final conversationId = await conversationManager.get();
    Map<String, String> response = {};
    if (conversationId == "") {
      response = {"state": "no_connection"};
    } else {
      response = {"state": "connection", "conversationId": conversationId};
    }

    this._currentState = response;
  }

  dispose() {
    _bottomBarBus.close();
  }
}

// global instance for access throughout the app
final bottomBusBloc = BottomBusBloc();
