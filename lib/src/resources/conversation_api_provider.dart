import "dart:async";
import "package:http/http.dart" as http;
import "dart:io";
import "dart:convert";

import "../models/conversation_model.dart";
import "../models/user_model.dart";
import "../services/cache_http.dart";
import "../services/login_manager.dart";
import "../../settings.dart";

class ConversationApiProvider {
  CacheHttp cache = CacheHttp();
  LoginManager loginManager = LoginManager();

  Future<Conversation> createConversation(String title) async {
    final jwt = await loginManager.getToken();
    final response = await http.post("$baseUrlCore/user/conversation",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $jwt"
        },
        body: jsonEncode({"title": title}));

    return Conversation.fromJson(jsonDecode(response.body));
  }

  void deleteConversation(String id) async {
    final jwt = await loginManager.getToken();
    await http.delete("$baseUrlCore/user/conversation/$id", headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $jwt"
    });
  }

  Future<List<Conversation>> fetchConversations() async {
    final jwt = await loginManager.getToken();
    try {
      final responseBody =
          await this.cache.fetch("$baseUrlCore/user/conversation", headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $jwt"
      });
      return jsonDecode(responseBody)
          .map<Conversation>(
              (conversation) => Conversation.fromJson(conversation))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  Future<Conversation> fetchConversation(String id) async {
    final jwt = await loginManager.getToken();
    try {
      final responseBody = await this
          .cache
          .fetch("$baseUrlCore/user/conversation/$id", headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $jwt"
      });
      return Conversation.fromJson(jsonDecode(responseBody));
    } catch (e) {
      throw e;
    }
  }

  Future<List<User>> fetchConversationMembers(String id) async {
    final jwt = await loginManager.getToken();
    try {
      final responseBody = await this
          .cache
          .fetch("$baseUrlCore/user/conversation/$id/member", headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $jwt"
      });
      return jsonDecode(responseBody)
          .map<User>((user) => User.fromJson(user))
          .toList();
    } catch (e) {
      throw e;
    }
  }
}
