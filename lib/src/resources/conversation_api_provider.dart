import "dart:async";
import "package:http/http.dart" as http;
import "dart:convert";

import "../models/conversation_model.dart";
import "../models/user_model.dart";

import "../../settings.dart";

class ConversationApiProvider {
  Future<Conversation> createConversation(String title) async {
    final response = await http.post("$baseUrlCore/user/conversation",
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"title": title}));

    return Conversation.fromJson(jsonDecode(response.body));
  }

  void deleteConversation(String id) async =>
      await http.delete("$baseUrlCore/user/conversation/$id");

  Future<List<Conversation>> fetchConversations() async {
    final response =
        await http.get("$baseUrlCore/user/$globalUserId/conversation");

    return jsonDecode(response.body)
        .map<Conversation>(
            (conversation) => Conversation.fromJson(conversation))
        .toList();
  }

  Future<Conversation> fetchConversation(String id) async {
    final response = await http.get("baseUrlCore/user/conversation/$id");

    return Conversation.fromJson(jsonDecode(response.body));
  }

  Future<List<User>> fetchConversationMembers(String id) async {
    final response = await http
        .get("$baseUrlCore/user/$globalUserId/conversation/$id/member");

    return jsonDecode(response.body)
        .map<User>((user) => User.fromJson(user))
        .toList();
  }
}
