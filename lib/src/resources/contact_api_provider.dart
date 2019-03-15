import "dart:async";
import "package:http/http.dart" as http;
import "dart:convert";

import "../models/user_model.dart";
import "../services/cache_http.dart";
import "../../settings.dart";

class ContactApiProvider {
  CacheHttp cache = CacheHttp();

  Future<void> init() async {
    await this.cache.init();
  }

  Future<List<User>> fetchContacts() async {
    try {
      final responseBody =
          await this.cache.fetch("$baseUrlCore/user/$globalUserId/contact/");
      return jsonDecode(responseBody)
          .map<User>((user) => User.fromJson(user))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  void createContact(User user) async =>
      await http.post("$baseUrlCore/user/contact",
          headers: {"Content-Type": "application/json"}, body: user.toJson);
}
