import "dart:async";
import "dart:convert";
import "dart:core";

import 'package:eventsource/eventsource.dart';
import "package:rxdart/rxdart.dart";
import "package:http/http.dart" as http;

import "../models/ping_model.dart";
import "../services/login_manager.dart";
import "../resources/contact_api_provider.dart";
import "../../settings.dart";

class HeartbeatReceiverBloc {
  LoginManager loginManager = new LoginManager();

  final Map<String, DateTime> lastSeen = {};
  final Map<String, String> status = {};

  final http.Client client = http.Client();
  final _statusFetcher = PublishSubject<Map<String, String>>();

  Observable<Map<String, String>> get stream => _statusFetcher.stream;

  HeartbeatReceiverBloc() {
    init();
  }

  init() async {
    final users = await contactApiProvider.fetchContacts();
    final authToken = await loginManager.getToken();

    // Setting up event
    for (final user in users) {
      this.lastSeen[user.id] = DateTime.fromMillisecondsSinceEpoch(0);
      this.status[user.id] = "";

      EventSource.connect(
              "$baseUrlHeartbeat/subscribe/${user.id}?token=$authToken",
              client: client)
          .then((es) {
        es.listen((Event event) {
          if (event.data == null) {
            return;
          }

          Ping ping = Ping.fromJson(jsonDecode(event.data));
          this.lastSeen[user.id] =
              DateTime.fromMillisecondsSinceEpoch(ping.time * 1000);
          _statusFetcher.sink.add({"user": user.id, "status": "online"});
          this.status[user.id] = "online";
        });
      }).catchError((e) => {});
    }

    // Setting up timers
    final checkDuration = Duration(seconds: 20);
    final timeoutDuration = Duration(minutes: 20);

    new Timer.periodic(checkDuration, (Timer t) {
      for (final user in users) {
        final now = new DateTime.now();
        final difference = now.difference(this.lastSeen[user.id]);

        if (difference > timeoutDuration) {
          _statusFetcher.sink.add({"user": user.id, "status": "offline"});
          this.status[user.id] = "offline";
        }
      }
    });
  }

  getLastStatus(String userId) {
    return status[userId];
  }

  flush() {
    _statusFetcher.sink.add({"user": "flushing", "status": ""});
  }

  dispose() {
    _statusFetcher.close();
    client.close();
  }
}

final heartbeatReceiverBloc = HeartbeatReceiverBloc();
