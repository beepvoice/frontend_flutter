import "package:rxdart/rxdart.dart";
import "../services/conversation_manager.dart";

class BottomBusBloc {
  final _bottomBarBus = PublishSubject<Map<String, String>>();
  final conversationManager = ConversationManager();

  BottomBusBloc() {
    _bottomBarBus.listen((data) => print(data));
  }

  Observable<Map<String, String>> get bus => _bottomBarBus.stream;

  publish(Map<String, String> message) async {
    _bottomBarBus.sink.add(message);
  }

  Future<Map<String, String>> getCurrentState() async {
    final conversationId = await conversationManager.get();
    Map<String, String> response = {};
    if (conversationId == "") {
      response = {"state": "no_connection"};
    } else {
      response = {"state": "connection", "conversationId": conversationId};
    }

    return response;
  }

  dispose() {
    _bottomBarBus.close();
  }
}

// global instance for access throughout the app
final bottomBusBloc = BottomBusBloc();
