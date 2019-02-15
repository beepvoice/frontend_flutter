import "dart:async";
import "contact_api_provider.dart";
import "../models/user_model.dart";

class Repository {
  final contactApiProvider = ContactApiProvider();

  Future<List<User>> fetchContacts() => contactApiProvider.fetchContactList();
}
