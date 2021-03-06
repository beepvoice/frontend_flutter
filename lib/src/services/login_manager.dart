import "dart:async";
import "dart:convert";
import "../models/user_model.dart";
import "../resources/login_api_provider.dart";
import "../resources/user_api_provider.dart";

import 'package:shared_preferences/shared_preferences.dart';

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
    return userString != null ? jsonDecode(userString) : null;
  }

  // Throws error status code if it occurs
  Future<void> initAuthentication(String phoneNumber) async {
    try {
      final nonce = await loginApiProvider.initAuthentication(phoneNumber);
      this.nonce = nonce;
    } catch (e) {
      throw e;
    }
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
      final payload = utf8.decode(base64Url.decode(parts[1]));
      final payloadMap = json.decode(payload);
      final userId = payloadMap['userid'];
      // Get user data
      final userApiProvider = UserApiProvider();
      final user =
          await userApiProvider.fetchUserById(userId);
      await prefs.setString("user", jsonEncode(user));
      return jwt;
    } catch (e) {
      throw e;
    }
  }

  Future<String> loginTest(String userId) async {
    try {
      final jwt = await loginApiProvider.loginTest(userId, "1");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", jwt);
      return jwt;
    } catch (e) {
      throw e;
    }
  }
}
