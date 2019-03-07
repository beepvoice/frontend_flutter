import "dart:async";
import "package:http/http.dart" as http;
import "dart:convert";

import "../models/user_model.dart";

import "../../settings.dart";

class LoginApiProvider {
  Future<String> initAuthentication(User user) async {
    final response = await http.post("$baseUrlLogin/init",
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone_number": user.phoneNumber}));
    if (response.statusCode == 400 || response.statusCode == 500) {
      throw response.statusCode;
    }
    return response.body;
  }

  Future<String> verifyOtp(String otp, String nonce, String clientid) async {
    final response = await http.post("$baseUrlLogin/verify",
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"code": otp, "nonce": nonce, "clientid": clientid}));
    if (response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 500) {
      throw response.statusCode;
    }
    return response.body;
  }

  Future<String> loginTest(String userId, String clientId) async {
    final response = await http.post("$baseUrlLogin/login",
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userid": userId, "clientid": clientId}));

    return response.body;
  }
}
