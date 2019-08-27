import "dart:io";
import "dart:convert";

import "package:rxdart/rxdart.dart";
import "package:eventsource/eventsource.dart";
import "package:http/http.dart" as http;

import "../services/login_manager.dart";
import "../models/user_model.dart";
import "../models/conversation_model.dart";
import "../../settings.dart";

class ConversationBloc {
  final _conversationsFetcher = PublishSubject<List<Conversation>>();
  final http.Client client = http.Client();

  LoginManager loginManager = LoginManager();

  Observable<List<Conversation>> get conversations =>
      _conversationsFetcher.stream;

  Observable<List<Conversation>> get pinnedConversations =>
      _conversationsFetcher.stream.map((conversationList) => conversationList
          .where((conversation) => conversation.pinned)
          .toList());

  Observable<Conversation> getConversation(String id) =>
      _conversationsFetcher.stream.map((conversationList) => conversationList
          .where((conversation) => (conversation.id == id))
          .first);

  ConversationBloc() {
    init();
  }

  init() async {
    final authToken = await loginManager.getToken();

    // REGISTERING THE CONVERSATION
    EventSource.connect("$baseUrlCore/user/conversation", headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $authToken"
    }).then((es) {
      es.listen((Event event) {
        if (event.data == null) {
          return;
        }

        List<Conversation> conversations = jsonDecode(event.data)
            .map<Conversation>(
                (conversation) => Conversation.fromJson(conversation))
            .toList();
        _conversationsFetcher.sink.add(conversations);
      });
    }).catchError((e) => {});
  }

  dispose() {
    _conversationsFetcher.close();
  }
}

class ConversationMembersBloc {
  final String conversationId;
  final _membersFetcher = PublishSubject<List<User>>();
  final http.Client client = http.Client();

  LoginManager loginManager = LoginManager();

  Observable<List<User>> get members => _membersFetcher.stream;

  ConversationMembersBloc(this.conversationId) {
    init();
  }

  init() async {
    final authToken = await loginManager.getToken();

    EventSource.connect(
        "$baseUrlCore/user/conversation/${this.conversationId}/member",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $authToken"
        }).then((es) {
      es.listen((Event event) {
        if (event.data == null) {
          return;
        }

        List<User> members = jsonDecode(event.data)
            .map<User>((user) => User.fromJson(user))
            .toList();
        _membersFetcher.sink.add(members);
      });
    }).catchError((e) => {});
  }

  dispose() {
    _membersFetcher.close();
    client.close();
  }
}

final conversationBloc = ConversationBloc();
