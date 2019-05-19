import "dart:async";
import "dart:convert";
import "dart:core";

import 'package:eventsource/eventsource.dart';
import "package:rxdart/rxdart.dart";
import "package:http/http.dart" as http;

import "../models/ping_model.dart";
import "../services/login_manager.dart";
import "../../settings.dart";

class HeartbeatReceiverBloc {
  LoginManager loginManager = new LoginManager();

  String userId;
  DateTime lastSeen;
  String status;

  final _coloursFetcher = PublishSubject<String>();

  final http.Client client;
  Observable<String> get colours => _coloursFetcher.stream;

  HeartbeatReceiverBloc(String userId) : client = http.Client() {
    this.userId = userId;
    lastSeen = DateTime.fromMillisecondsSinceEpoch(0);
    status = "";

    loginManager.getToken().then((token) {
      EventSource.connect("$baseUrlHeartbeat/subscribe/$userId?token=$token",
              client: client)
          .then((es) {
        es.listen((Event event) {
          // Guard against empty packets
          if (event.data == null) {
            return;
          }

          Ping ping = Ping.fromJson(jsonDecode(event.data));
          lastSeen = DateTime.fromMillisecondsSinceEpoch(ping.time * 1000);
          status = ping.status;
        });
        final oneMinute = Duration(minutes: 1);
        final timeoutDuration = Duration(minutes: 30);
        new Timer.periodic(oneMinute, (Timer t) {
          if (status == "on_call") {
            _coloursFetcher.sink.add("busy");
          } else {
            final now = new DateTime.now();
            final difference = now.difference(this.lastSeen);
            if (difference > timeoutDuration) {
              _coloursFetcher.sink.add("online");
            } else {
              _coloursFetcher.sink.add("offline");
            }
          }
        });
      }).catchError((e) =>
              {}); // Add actual error handling logic for stopped connections
    });
  }

  dispose() {
    _coloursFetcher.close();
    client.close();
  }
}
