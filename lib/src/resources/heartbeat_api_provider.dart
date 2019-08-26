import "dart:async";
import "dart:io";
import 'dart:convert';

import "http_client.dart";
import "../../settings.dart";
import "../services/login_manager.dart";

class HeartbeatApiProvider {
  LoginManager loginManager = LoginManager();

  Future<void> ping({String status = ""}) async {
    final jwt = await loginManager.getToken();
    await globalHttpClient.post("$baseUrlHeartbeat/ping",
        headers: {HttpHeaders.authorizationHeader: "Bearer $jwt"},
        body: jsonEncode({"status": status}));
  }
}

var heartbeatApiProvider = HeartbeatApiProvider();
