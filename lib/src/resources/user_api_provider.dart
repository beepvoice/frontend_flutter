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

  Future<User> createUser(
      String username, String firstName, String lastName, String phoneNumber, String bio, String profilePic) async {
    final jwt = loginManager.getToken();
    final response = await http.post("$baseUrlCore/user",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $jwt"
        },
        body: jsonEncode({
          "username": username,
          "first_name": firstName,
          "last_name": lastName,
          "phone_number": phoneNumber,
          "bio": bio,
          "profile_pic": profilePic
        }));

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
    final jwt = await loginManager.getToken();
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

  Future<User> fetchUserByUsername(String username) async {
    final jwt = await loginManager.getToken();
    try {
      final responseBody =
          await this.cache.fetch("$baseUrlCore/user/username/$username", headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $jwt"
      });
      return User.fromJson(jsonDecode(responseBody));
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateUser(String firstName, String lastName) async {
    final jwt = await loginManager.getToken();
    final user = await loginManager.getUser();
    final finalFirstName =
        firstName != "" ? firstName : user != null ? user.firstName : "";
    final finalLastName =
        lastName != "" ? lastName : user != null ? user.lastName : "";
    await http.patch("$baseUrlCore/user",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $jwt"
        },
        body: jsonEncode({
          "first_name": finalFirstName,
          "last_name": finalLastName,
        }));
  }
}

var userApiProvider = UserApiProvider();
