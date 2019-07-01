import "package:rxdart/rxdart.dart";

import "../resources/contact_api_provider.dart";
import "../models/user_model.dart";

class ContactBloc {
  final _contactsFetcher = PublishSubject<List<User>>();

  Observable<List<User>> get contacts => _contactsFetcher.stream;

  fetchContacts() async {
    List<User> contactList = await contactApiProvider.fetchContacts();
    _contactsFetcher.sink.add(contactList);
    return contactList;
  }

  dispose() {
    _contactsFetcher.close();
  }
}

final contactBloc = ContactBloc();
