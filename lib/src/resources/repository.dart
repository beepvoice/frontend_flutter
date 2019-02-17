import "dart:async";

import "contact_api_provider.dart";
import "conversation_api_provider.dart";

import "../models/user_model.dart";
import "../models/conversation_model.dart";

class Repository {
  final contactApiProvider = ContactApiProvider();
  final conversationApiProvider = ConversationApiProvider();

  Future<List<User>> fetchContacts() => contactApiProvider.fetchContacts();

  Future<List<Conversation>> fetchConversations() =>
      conversationApiProvider.fetchConversations();

  Future<List<User>> fetchConversationMembers(String id) =>
      conversationApiProvider.fetchConversationMembers(id);
}
