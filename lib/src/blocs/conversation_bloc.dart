import "package:rxdart/rxdart.dart";

import "../resources/repository.dart";
import "../models/user_model.dart";
import "../models/conversation_model.dart";

class ConversationsBloc {
  final _repository = Repository();
  final _conversationsFetcher = PublishSubject<List<Conversation>>();

  Observable<List<Conversation>> get conversations =>
      _conversationsFetcher.stream;

  fetchConversations() async {
    List<Conversation> conversationList =
        await _repository.fetchConversations();
    _conversationsFetcher.sink.add(conversationList);
  }

  dispose() {
    _conversationsFetcher.close();
  }
}

class ConversationMembersBloc {
  final String conversationId;
  final _repository = Repository();
  final _membersFetcher = PublishSubject<List<User>>();

  ConversationMembersBloc(this.conversationId);

  Observable<List<User>> get members => _membersFetcher.stream;

  fetchMembers() async {
    List<User> memberList =
        await _repository.fetchConversationMembers(conversationId);
    _membersFetcher.sink.add(memberList);
  }

  dispose() {
    _membersFetcher.close();
  }
}
