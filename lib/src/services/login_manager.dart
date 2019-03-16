import "../resources/login_api_provider.dart";
import "../models/user_model.dart";
import "../resources/user_api_provider.dart";

import 'package:shared_preferences/shared_preferences.dart';

class LoginManager {
  final loginApiProvider = LoginApiProvider();
  final userApiProvider = UserApiProvider();
  String clientid;
  String nonce;

  // Returns JWT, blank string if nothing is found
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    return token;
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
      return jwt;
    } catch (e) {
      throw e;
    }
  }

  Future<String> loginTest(String phoneNumber) async {
    try {
      User user = await userApiProvider.fetchUserByPhone(phoneNumber);
      final jwt = await loginApiProvider.loginTest(user.id, "1");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", jwt);
      return jwt;
    } catch (e) {
      throw e;
    }
  }
}
