import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;

import "../models/user_model.dart";
import "../../settings.dart";

class UserApiProvider {
  Future<User> createUser(User user) async {
    // Prob need to add the headers
    final response = await http.post("$baseUrlCore/user", body: user.toJson());

    return User.fromJson(jsonDecode(response.body));
  }

  Future<User> fetchUserByPhone(String phoneNumber) async {
    final uri = Uri.https(baseUrlCore, "/user", {"phone_number": phoneNumber});
    final response = await http.get(uri);

    return User.fromJson(jsonDecode(response.body));
  }

  Future<User> fetchUserById(String id) async {
    final response = await http.get("$baseUrlCore/user/id/$id");

    return User.fromJson(jsonDecode(response.body));
  }
}
