import "dart:async";
import "../resources/login_api_provider.dart";
import "../resources/user_api_provider.dart";

class RegisterManager {
  final loginApiProvider = LoginApiProvider();
  final userApiProvider = UserApiProvider();
  String nonce;

  // Throws error status code if it occurs
  Future<void> initAuthentication(String phoneNumber) async {
    try {
      final nonce = await loginApiProvider.initAuthentication(phoneNumber);
      this.nonce = nonce;
    } catch (e) {
      throw e;
    }
  }

  Future<void> registerUser(String firstName, String lastName, String phoneNumber, String otp) async {
    await userApiProvider.registerUser(firstName, lastName, phoneNumber, otp, this.nonce);
  }
}
