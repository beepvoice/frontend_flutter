import "dart:async";
import "package:http/http.dart" show Client;
import "dart:convert";
import "../models/user_model.dart";

class ContactApiProvider {
  Client client = Client();

  Future<List<User>> fetchContactList() async {
    final response = await client.get(
        "http://localhost:10200/user/u-3d19fb283ddb14fb5c15191438b5b69a/contact");

    return jsonDecode(response.body)
        .map<User>((user) => User.fromJson(user))
        .toList();
  }
}
