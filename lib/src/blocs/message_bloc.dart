import "package:rxdart/rxdart.dart";

class MessageBloc {
  final _messageBus = PublishSubject<Map<String, String>>();

  MessageBloc() {
    _messageBus.listen((data) => print("MESSAGE: $data"));
  }

  Observable<Map<String, String>> get bus => _messageBus.stream;

  publish(Map<String, String> message) async {
    _messageBus.sink.add(message);
  }

  dispose() {
    _messageBus.close();
  }
}

// global instance for access throughout the app
final messageChannel = MessageBloc();
