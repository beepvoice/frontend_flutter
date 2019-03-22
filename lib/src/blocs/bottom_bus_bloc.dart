import "package:rxdart/rxdart.dart";

class BottomBusBloc {
  final _bottomBarBus = PublishSubject<Map<String, String>>();
  Map<String, String> _lastMessage = {"state": "no_connection"};

  BottomBusBloc() {
    _bottomBarBus.listen((data) => print(data));
  }

  Observable<Map<String, String>> get bus => _bottomBarBus.stream;
  Map<String, String> get lastMessage => _lastMessage;

  publish(Map<String, String> message) async {
    print(message);
    _lastMessage = message;
    _bottomBarBus.sink.add(message);
  }

  dispose() {
    _bottomBarBus.close();
  }
}

// global instance for access throughout the app
final bottomBusBloc = BottomBusBloc();
