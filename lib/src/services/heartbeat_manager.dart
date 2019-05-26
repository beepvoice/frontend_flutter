import "dart:async";
import "dart:core";

import "../resources/heartbeat_api_provider.dart";

class HeartbeatSendManager {
  HeartbeatApiProvider heartbeatApiProvider;

  String status;

  HeartbeatSendManager() {
    status = "a";
    heartbeatApiProvider = HeartbeatApiProvider();
    const transmitInterval = const Duration(seconds: 20);
    new Timer.periodic(transmitInterval, (Timer t) {
      heartbeatApiProvider.ping(status: this.status);
    });
  }

  void setStatus(String status) {
    this.status = status;
  }
}
