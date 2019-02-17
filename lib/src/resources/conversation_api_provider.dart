import "dart:async";
import "package:http/http.dart" show Client;
import "dart:convert";

import "../models/conversation_model.dart";
import "../models/user_model.dart";

import "../../settings.dart";

class ConversationApiProvider {
  Client _client = Client();

  Future<List<Conversation>> fetchConversations() async {
    final response =
        await _client.get("$baseUrlCore/user/$globalUserId/conversation");

    return jsonDecode(response.body)
        .map<Conversation>(
            (conversation) => Conversation.fromJson(conversation))
        .toList();
  }

  Future<List<User>> fetchConversationMembers(String id) async {
    final response = await _client
        .get("$baseUrlCore/user/$globalUserId/conversation/$id/member");

    return jsonDecode(response.body)
        .map<User>((user) => User.fromJson(user))
        .toList();
  }
}
