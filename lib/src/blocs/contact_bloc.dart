import "package:rxdart/rxdart.dart";

import "../resources/repository.dart";
import "../models/user_model.dart";

// TODO: SHOULD BE A INHERITED SCOPED BLOC Widget
class ContactBloc {
  final _repository = Repository();
  final _contactsFetcher = PublishSubject<List<User>>();

  Observable<List<User>> get contacts => _contactsFetcher.stream;

  fetchContacts() async {
    List<User> contactList = await _repository.fetchContacts();
    _contactsFetcher.sink.add(contactList);
  }

  dispose() {
    _contactsFetcher.close();
  }
}
