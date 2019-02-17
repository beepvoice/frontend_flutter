import "package:rxdart/rxdart.dart";

class BottomBarBus {
  final _bottomBarBus = PublishSubject<Map<String, dynamic>>();

  Observable<Map<String, dynamic>> get bus => _bottomBarBus.stream;

  publish(Map<String, dynamic> message) async {
    _bottomBarBus.sink.add(message);
  }

  dispose() {
    _bottomBarBus.close();
  }
}
