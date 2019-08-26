import "dart:async";
import "dart:io";

import "http_client.dart";
import "../models/user_model.dart";
import "../services/login_manager.dart";
import "../../settings.dart";

class ContactApiProvider {
  LoginManager loginManager = LoginManager();

  Future<void> createContact(User user) async {
    final jwt = await loginManager.getToken();

    await globalHttpClient.post("$baseUrlCore/user/contact",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $jwt"
        },
        body: user.toJson);
  }
}

var contactApiProvider = ContactApiProvider();
