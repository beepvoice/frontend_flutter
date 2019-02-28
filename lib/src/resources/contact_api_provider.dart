import "dart:async";
import "package:http/http.dart" as http;
import "dart:convert";

import "../models/user_model.dart";
import "../../settings.dart";

class ContactApiProvider {
  Future<List<User>> fetchContacts() async {
    final response = await http.get("$baseUrlCore/user/$globalUserId/contact");

    return jsonDecode(response.body)
        .map<User>((user) => User.fromJson(user))
        .toList();
  }

  void createContact(User user) async =>
      await http.post("$baseUrlCore/user/contact",
          headers: {"Content-Type": "application/json"}, body: user.toJson);
}
