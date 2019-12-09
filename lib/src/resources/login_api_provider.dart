import "dart:async";
import "package:http/http.dart" as http;
import "dart:convert";
import "dart:io";

import "../../settings.dart";

class LoginApiProvider {
  Future<String> initAuthentication(String phoneNumber) async {
    final response = await http.post("$baseUrlLogin/init",
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: jsonEncode({"phone_number": phoneNumber}));
    if (response.statusCode == 400 || response.statusCode == 500) {
      throw response.statusCode;
    }
    return response.body;
  }

  Future<String> initAuthenticationBypass(String phoneNumber) async {
    final response = await http.post("$baseUrlLogin/init/bypass",
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: jsonEncode({"phone_number": phoneNumber}));
    if (response.statusCode == 400 || response.statusCode == 500) {
      throw response.statusCode;
    }
    return response.body;
  }

  Future<String> verifyOtp(String otp, String nonce, String clientid) async {
    final response = await http.post("$baseUrlLogin/verify",
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: jsonEncode({"code": otp, "nonce": nonce, "clientid": clientid}));
    if (response.statusCode == 400 ||
        response.statusCode == 404 ||
        response.statusCode == 500) {
      throw HttpException("Error verifying OTP. HTTP ${response.statusCode}: ${response.body}");
    }
    return response.body;
  }

  Future<String> loginTest(String userId, String clientId) async {
    final response = await http.post("$baseUrlLogin/login",
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: jsonEncode({"userid": userId, "clientid": clientId}));

    return response.body;
  }
}

var loginApiProvider = LoginApiProvider();
