import "dart:async";
import "dart:io";
import 'dart:convert';
import "package:http/http.dart" as http;

import "../../settings.dart";
import "../services/login_manager.dart";

class HeartbeatApiProvider {
  LoginManager loginManager = LoginManager();

  Future<void> ping({String status = ""}) async {
    final jwt = await loginManager.getToken();
    print("GOT JWT: $jwt");
    await http.post("$baseUrlHeartbeat/ping",
        headers: {HttpHeaders.authorizationHeader: "Bearer $jwt"},
        body: jsonEncode({"status": status}));
  }
}
