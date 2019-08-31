import "package:rxdart/rxdart.dart";

import "../resources/conversation_api_provider.dart";
import "../models/user_model.dart";
import "../models/conversation_model.dart";

class ConversationsBloc {
  final _conversationsFetcher = PublishSubject<List<Conversation>>();

  Observable<List<Conversation>> get conversations =>
      _conversationsFetcher.stream;

  Observable<List<Conversation>> get pinnedConversations =>
      _conversationsFetcher.stream.map((conversationList) => conversationList
          .where((conversation) => conversation.pinned ?? false)
          .toList());

  fetchConversations() async {
    List<Conversation> conversationList =
        await conversationApiProvider.fetchConversations();
    _conversationsFetcher.sink.add(conversationList);
  }

  dispose() {
    _conversationsFetcher.close();
  }
}

// Should be a scoped widget
class ConversationMembersBloc {
  final String conversationId;
  final _provider = ConversationApiProvider();
  final _membersFetcher = PublishSubject<List<User>>();

  ConversationMembersBloc(this.conversationId);

  Observable<List<User>> get members => _membersFetcher.stream;

  fetchMembers() async {
    List<User> memberList =
        await _provider.fetchConversationMembers(conversationId);
    print(memberList);
    _membersFetcher.sink.add(memberList);
  }

  dispose() {
    _membersFetcher.close();
  }
}

final conversationsBloc = ConversationsBloc();
