import "package:rxdart/rxdart.dart";

import "../resources/contact_api_provider.dart";
import "../models/user_model.dart";

// TODO: SHOULD BE A INHERITED SCOPED BLOC Widget
class ContactBloc {
  final _provider = ContactApiProvider();
  final _contactsFetcher = PublishSubject<List<User>>();

  Observable<List<User>> get contacts => _contactsFetcher.stream;

  fetchContacts() async {
    List<User> contactList = await _provider.fetchContacts();
    _contactsFetcher.sink.add(contactList);
  }

  dispose() {
    _contactsFetcher.close();
  }
}
