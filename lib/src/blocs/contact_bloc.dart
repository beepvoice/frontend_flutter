import "package:rxdart/rxdart.dart";
import "../resources/repository.dart";
import "../models/user_model.dart";

class ContactBloc {
  final _repository = Repository();
  final _contactsFetcher = PublishSubject<List<User>>();

  Observable<List<User>> get allContacts => _contactsFetcher.stream;

  fetchAllContacts() async {
    List<User> contactList = await _repository.fetchContacts();
    _contactsFetcher.sink.add(contactList);
  }

  dispose() {
    _contactsFetcher.close();
  }
}
