import "dart:async";
import "package:http/http.dart" as http;
import "dart:convert";

import "../models/conversation_model.dart";
import "../models/user_model.dart";

import "../services/cache_http.dart";

import "../../settings.dart";

class ConversationApiProvider {
  CacheHttp cache;

  Future<void> init() async {
    this.cache = new CacheHttp();
    await this.cache.init();
  }

  Future<Conversation> createConversation(String title) async {
    final response = await http.post("$baseUrlCore/user/conversation",
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"title": title}));

    return Conversation.fromJson(jsonDecode(response.body));
  }

  void deleteConversation(String id) async =>
      await http.delete("$baseUrlCore/user/conversation/$id");

  Future<List<Conversation>> fetchConversations() async {
    try {
      final responseBody = await this.cache.fetch("$baseUrlCore/user/$globalUserId/conversation");
      return jsonDecode(responseBody)
          .map<Conversation>(
              (conversation) => Conversation.fromJson(conversation))
          .toList();
    } catch(e) {
      throw e;
    }
  }

  Future<Conversation> fetchConversation(String id) async {
    try {
      final responseBody = await this.cache.fetch("$baseUrlCore/user/conversation/$id");
      return Conversation.fromJson(jsonDecode(responseBody));
    } catch(e) {
      throw e;
    }
  }

  Future<List<User>> fetchConversationMembers(String id) async {
    try {
      final responseBody = await this.cache.fetch("$baseUrlCore/user/$globalUserId/conversation/$id/member");
      return jsonDecode(responseBody)
          .map<User>((user) => User.fromJson(user))
          .toList();
    } catch(e) {
      throw e;
    }
  }
}
