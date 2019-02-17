import "dart:async";
import "package:http/http.dart" show Client;
import "dart:convert";

import "../models/user_model.dart";

import "../../settings.dart";

class ContactApiProvider {
  Client client = Client();

  Future<List<User>> fetchContacts() async {
    final response =
        await client.get("$baseUrlCore/user/$globalUserId/contact");

    return jsonDecode(response.body)
        .map<User>((user) => User.fromJson(user))
        .toList();
  }
}
