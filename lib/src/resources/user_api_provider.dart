import "dart:async";
import "dart:convert";
import "dart:io";
import "package:http/http.dart" as http;

import "../models/user_model.dart";
import "../services/cache_http.dart";
import "../services/login_manager.dart";
import "../../settings.dart";

class UserApiProvider {
  CacheHttp cache = CacheHttp();
  LoginManager loginManager = LoginManager();

  Future<User> createUser(User user) async {
    final jwt = loginManager.getToken();
    final response = await http.post("$baseUrlCore/user",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $jwt"
        },
        body: user.toJson());

    return User.fromJson(jsonDecode(response.body));
  }

  Future<User> fetchUserByPhone(String phoneNumber) async {
    final jwt = loginManager.getToken();
    try {
      final responseBody = await this
          .cache
          .fetch("$baseUrlCore/user?phone_number=$phoneNumber", headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $jwt"
      });
      return User.fromJson(jsonDecode(responseBody));
    } catch (e) {
      throw e;
    }
  }

  Future<User> fetchUserById(String id) async {
    final jwt = loginManager.getToken();
    try {
      final responseBody =
          await this.cache.fetch("$baseUrlCore/user/id/$id", headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $jwt"
      });
      return User.fromJson(jsonDecode(responseBody));
    } catch (e) {
      throw e;
    }
  }
}
