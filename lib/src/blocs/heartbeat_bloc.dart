import "dart:async";
import "dart:convert";
import "dart:core";

import 'package:eventsource/eventsource.dart';
import "package:rxdart/rxdart.dart";
import "package:http/http.dart" as http;

import "../models/ping_model.dart";
import "../models/user_model.dart";
import "../services/login_manager.dart";
import "../blocs/contact_bloc.dart";
import "../../settings.dart";

class HeartbeatReceiverBloc {
  LoginManager loginManager = new LoginManager();

  final List<StreamSubscription> esHandles = [];
  final Map<String, DateTime> lastSeen = {};
  final Map<String, String> status = {};

  final http.Client client = http.Client();
  final _statusFetcher = PublishSubject<Map<String, String>>();

  List<User> lastContacts;

  Observable<Map<String, String>> get stream => _statusFetcher.stream;

  HeartbeatReceiverBloc() {
    init();
  }

  init() async {
    final authToken = await loginManager.getToken();

    contactBloc.contacts.listen((List<User> contacts) {
      if (contacts == this.lastContacts) {
        return;
      }

      esHandles.forEach((handle) async => await handle.cancel());

      for (final contact in contacts) {
        this.lastSeen[contact.id] = DateTime.fromMillisecondsSinceEpoch(0);
        this.status[contact.id] = "offline";

        EventSource.connect(
                "$baseUrlHeartbeat/subscribe/${contact.id}?token=$authToken",
                client: this.client)
            .then((es) {
          StreamSubscription handle = es.listen((Event event) {
            if (event.data == null) {
              return;
            }

            Ping ping = Ping.fromJson(jsonDecode(event.data));
            this.lastSeen[contact.id] =
                DateTime.fromMillisecondsSinceEpoch(ping.time * 1000);
            _statusFetcher.sink.add({"user": contact.id, "status": "online"});
            this.status[contact.id] = "online";
          });

          esHandles.add(handle);
        });
      }
      this.lastContacts = contacts;
    });

    // Setting up timers to send the heartbeat to the stream
    final checkDuration = Duration(seconds: 20);
    final timeoutDuration = Duration(minutes: 1);

    Timer.periodic(checkDuration, (Timer t) {
      this.lastSeen.forEach((id, lastSeen) {
        this.status[id] =
            (DateTime.now().difference(lastSeen) < timeoutDuration)
                ? "online"
                : "offline";
        _statusFetcher.sink.add({"user": id, "status": this.status[id]});
      });
    });
  }

  getLastStatus(String userId) {
    return status[userId];
  }

  dispose() {
    _statusFetcher.close();
    client.close();
  }
}

final heartbeatReceiverBloc = HeartbeatReceiverBloc();
