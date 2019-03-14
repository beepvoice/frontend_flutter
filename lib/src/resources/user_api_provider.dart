import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;

import "../models/user_model.dart";
import "../services/cache_http.dart";
import "../../settings.dart";

class UserApiProvider {
  CacheHttp cache;

  Future<void> init() async {
    this.cache = new CacheHttp();
    await this.cache.init();
  }

  Future<User> createUser(User user) async {
    // Prob need to add the headers
    final response = await http.post("$baseUrlCore/user",
        headers: {"Content-Type": "application/json"}, body: user.toJson());

    return User.fromJson(jsonDecode(response.body));
  }

  Future<User> fetchUserByPhone(String phoneNumber) async {
    try {
      final responseBody = await this.cache.fetch("$baseUrlCore/user?phone_number=$phoneNumber");
      return User.fromJson(jsonDecode(responseBody));
    } catch(e) {
      throw e;
    }
  }

  Future<User> fetchUserById(String id) async {
    try {
      final responseBody = await this.cache.fetch("$baseUrlCore/user/id/$id");
      return User.fromJson(jsonDecode(responseBody));
    } catch(e) {
      throw e;
    }
  }
}
