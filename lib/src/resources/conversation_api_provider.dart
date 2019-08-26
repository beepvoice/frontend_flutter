import "dart:async";
import "dart:io";
import "dart:convert";

import "../resources/http_client.dart";
import "../models/conversation_model.dart";
import "../models/user_model.dart";
import "../services/cache_http.dart";
import "../services/login_manager.dart";
import "../../settings.dart";

import "./picture_api_provider.dart";

class ConversationApiProvider {
  CacheHttp cache = CacheHttp();
  LoginManager loginManager = LoginManager();

  Future<Conversation> createConversation(String title,
      {File profile, bool dm = false}) async {
    final jwt = await loginManager.getToken();

    String profileURL = "";
    if (profile != null) {
      profileURL = await pictureApiProvider.uploadPicture(profile);
    }

    final response = await globalHttpClient.post(
        "$baseUrlCore/user/conversation",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $jwt"
        },
        body: jsonEncode({"title": title, "picture": profileURL, "dm": dm}));

    return Conversation.fromJson(jsonDecode(response.body));
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

  Future<void> deleteConversation(String id) async {
    final jwt = await loginManager.getToken();
    try {
      await globalHttpClient
          .delete("$baseUrlCore/user/conversation/$id", headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $jwt"
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> createConversationMember(
      String conversationId, String userId) async {
    final jwt = await loginManager.getToken();
    await globalHttpClient.post(
        "$baseUrlCore/user/conversation/$conversationId/member",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $jwt"
        },
        body: jsonEncode({"id": userId}));
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

var conversationApiProvider = ConversationApiProvider();
