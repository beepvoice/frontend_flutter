import 'dart:io';
import 'dart:async';
import 'package:connectivity/connectivity.dart';

/// Singleton class to get a stream of the current network connection status.
class ConnectionStatus {
  static final ConnectionStatus _singleton = ConnectionStatus._internal();
  static final Connectivity _connectivity = Connectivity();

  StreamController<bool> _connectionChangeController;

  bool _hasConnection = false;

  /// Stream of current connection status. Only updates when there is a change in connection.
  Stream<bool> get connectionChange => _connectionChangeController.stream;

  /// Private internal constructor for the Singleton
  ConnectionStatus._internal() {
    // Only call the init function when there is a subscriber to the stream
    _connectionChangeController =
        StreamController<bool>.broadcast(onListen: _init);
  }

  _init() async {
    _checkConnection();

    // Recheck the connection when device connectivity changes (e.g. WiFi enabled/disabled)
    _connectivity.onConnectivityChanged.listen((result) => _checkConnection());

    // Set a timer to check the connection periodically
    Timer.periodic(Duration(seconds: 20), (Timer t) {
      _checkConnection();
    });
  }

  /// Checks the current connection status and updates _connectionChangeController if required.
  Future<bool> _checkConnection() async {
    bool prevConnection = _hasConnection;

    try {
      // Verify connection by resolving example.com
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _hasConnection = true;
      } else {
        _hasConnection = false;
      }
    } on SocketException {
      _hasConnection = false;
    }

    // Update the stream controller if there is a change in connection
    if (prevConnection != _hasConnection) {
      _connectionChangeController.add(_hasConnection);
    }

    return _hasConnection;
  }

  void dispose() {
    _connectionChangeController.close();
  }

  factory ConnectionStatus() {
    return _singleton;
  }
}
