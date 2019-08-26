import "dart:async";
import "dart:io";

import "http_client.dart";
import "../models/user_model.dart";
import "../services/cache_http.dart";
import "../services/login_manager.dart";
import "../../settings.dart";

class ContactApiProvider {
  CacheHttp cache = CacheHttp();
  LoginManager loginManager = LoginManager();

  /*
  Future<List<User>> fetchContacts() async {
    final jwt = await loginManager.getToken();

    try {
      final responseBody =
          await this.cache.fetch("$baseUrlCore/user/contact", headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $jwt"
      });
      return jsonDecode(responseBody)
          .map<User>((user) => User.fromJson(user))
          .toList();
    } catch (e) {
      throw e;
    }
  } */

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
