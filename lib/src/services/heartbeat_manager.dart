import "dart:async";
import "dart:core";

import "../resources/heartbeat_api_provider.dart";

class HeartbeatSendManager {
  HeartbeatApiProvider heartbeatApiProvider;

  String status;

  HeartbeatSendManager() {
    status = "";
    heartbeatApiProvider = HeartbeatApiProvider();
    const oneMinute = const Duration(minutes: 1);
    new Timer.periodic(oneMinute, (Timer t) => heartbeatApiProvider.ping(status:this.status));
  }

  void setStatus(String status) {
    this.status = status;
  }
}
