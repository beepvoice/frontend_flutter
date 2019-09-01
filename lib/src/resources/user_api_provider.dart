import "dart:async";
import "dart:convert";
import "dart:io";
import "dart:core";
import "package:http/http.dart" as http;

import "../models/user_model.dart";
import "../services/cache_http.dart";
import "../services/login_manager.dart";
import "../../settings.dart";

import "./picture_api_provider.dart";

class UserApiProvider {
  CacheHttp cache = CacheHttp();
  LoginManager loginManager = LoginManager();
  PictureApiProvider pictureApiProvider = new PictureApiProvider();

  Future<User> createUser(String username, String firstName, String lastName,
      String phoneNumber, String bio, File profilePic) async {
    final jwt = loginManager.getToken();

    // Upload picture
    var profileUrl = "";
    if (profilePic != null) {
      profileUrl = await pictureApiProvider.uploadPicture(profilePic);
    }

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
          "profile_pic": profileUrl
        }));

    return User.fromJson(jsonDecode(response.body));
  }

  Future<User> fetchUserByPhone(String phoneNumber) async {
    final jwt = await loginManager.getToken();
    final encoded = Uri.encodeComponent(phoneNumber);
    try {
      final responseBody = await this
          .cache
          .fetch("$baseUrlCore/user?phone_number=$encoded", headers: {
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
      final responseBody = await this
          .cache
          .fetch("$baseUrlCore/user/username/$username", headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $jwt"
      });
      return User.fromJson(jsonDecode(responseBody));
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateUser(
      {String firstName: "",
      String lastName: "",
      String username: "",
      String bio: "",
      File profilePic}) async {
    final jwt = await loginManager.getToken();
    final user = await loginManager.getUser();

    // Upload picture
    var profileUrl = "";
    if (profilePic != null) {
      profileUrl = await pictureApiProvider.uploadPicture(profilePic);
    }

    final finalFirstName =
        firstName != "" ? firstName : user != null ? user.firstName : "";
    final finalLastName =
        lastName != "" ? lastName : user != null ? user.lastName : "";
    final finalBio = bio != "" ? bio : user != null ? user.bio : "";
    final finalUsername =
        username != "" ? username : user != null ? user.username : "";
    final finalProfileUrl =
        profileUrl != "" ? profileUrl : user != null ? user.profilePic : "";

    await http.patch("$baseUrlCore/user",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $jwt"
        },
        body: jsonEncode({
          "first_name": finalFirstName,
          "last_name": finalLastName,
          "bio": finalBio,
          "username": finalUsername,
          "profile_pic": finalProfileUrl
        }));
  }
}

var userApiProvider = UserApiProvider();
