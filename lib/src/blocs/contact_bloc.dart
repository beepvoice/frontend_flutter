import "dart:io";
import "dart:convert";

import "package:rxdart/rxdart.dart";
import "package:eventsource/eventsource.dart";
import "package:http/http.dart" as http;

import "../services/login_manager.dart";
import "../models/user_model.dart";
import "../../settings.dart";

class ContactBloc {
  final _contactsFetcher = PublishSubject<List<User>>();
  LoginManager loginManager = LoginManager();

  final http.Client client = http.Client();

  Observable<List<User>> get contacts => _contactsFetcher.stream;

  init() async {
    final authToken = await loginManager.getToken();

    EventSource.connect("$baseUrlCore/user/contact", headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $authToken"
    }).then((es) {
      es.listen((Event event) {
        if (event.data == null) {
          return;
        }

        List<User> contacts = jsonDecode(event.data)
            .map<User>((user) => User.fromJson(user))
            .toList();
        _contactsFetcher.sink.add(contacts);
      });
    }).catchError((e) => {});
  }

  dispose() {
    _contactsFetcher.close();
  }
}

final contactBloc = ContactBloc();
