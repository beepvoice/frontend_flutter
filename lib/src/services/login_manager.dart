import "dart:async";
import "dart:convert";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';

import "../models/user_model.dart";
import "../resources/login_api_provider.dart";
import "../resources/user_api_provider.dart";

class LoginManager {
  final loginApiProvider = LoginApiProvider();
  String clientid;
  String nonce;

  // Returns JWT, blank string if nothing is found
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    return token;
  }

  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString("user");
    return userString != null ? User.fromJson(jsonDecode(userString)) : null;
  }

  // Throws error status code if it occurs
  Future<void> initAuthentication(String phoneNumber) async {
    try {
      final nonce = await loginApiProvider.initAuthentication(phoneNumber);
      this.nonce = nonce;
      this.clientid = await UniqueIdentifier.serial;
    } catch (e) {
      throw e;
    }
  }

  Future<void> initAuthenticationBypass(String phoneNumber) async {
    try {
      final nonce =
          await loginApiProvider.initAuthenticationBypass(phoneNumber);
      this.nonce = nonce;
      this.clientid = await UniqueIdentifier.serial;
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", "");
  }

  // Throws error status code if it occurs, otherwise returns jwt
  Future<String> processOtp(String otp) async {
    try {
      final jwt =
          await loginApiProvider.verifyOtp(otp, this.nonce, this.clientid);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", jwt);

      // Parse jwt to get userid
      final parts = jwt.split('.');
      if (parts.length != 3) {
        throw Exception('invalid token');
      }

      String payloadString = parts[1];

      while (((payloadString.length * 6) % 8) != 0) payloadString += "=";

      final payload = utf8.decode(base64Url.decode(payloadString));
      final payloadMap = json.decode(payload);
      final userId = payloadMap['userid'];

      // Get user data
      final userApiProvider = UserApiProvider();
      final user = await userApiProvider.fetchUserById(userId);
      await prefs.setString("user", jsonEncode(user));
      return jwt;
    } catch (e) {
      throw e;
    }
  }
}
