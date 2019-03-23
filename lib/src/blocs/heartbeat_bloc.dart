import "dart:async";
import "dart:convert";
import "dart:core";
import "dart:ui";

import 'package:eventsource/eventsource.dart';
import "package:rxdart/rxdart.dart";

import "../models/ping_model.dart";
import "../services/login_manager.dart";
import "../../settings.dart";

class HeartbeatReceiverBloc {
  LoginManager loginManager = new LoginManager();

  String userId;
  DateTime lastSeen;
  String status;

  final _coloursFetcher = PublishSubject<Color>();
  Observable<Color> get colours => _coloursFetcher.stream;

  HeartbeatReceiverBloc(String userId) {
    this.userId = userId;
    lastSeen = DateTime.fromMillisecondsSinceEpoch(0);
    status = "";

    loginManager.getToken().then((token) {
      EventSource.connect("$baseUrlHeartbeat/subscribe/$userId?token=$token").then((es) {
        es.listen((Event event) {
          Ping ping = Ping.fromJson(jsonDecode(event.data));
          lastSeen = DateTime.fromMillisecondsSinceEpoch(ping.timestamp);
          status = ping.status;
        });

        final oneMinute = Duration(minutes: 1);
        final timeoutDuration = Duration(minutes: 30);
        new Timer.periodic(oneMinute, (Timer t) {
          if (status == "on_call") {
            _coloursFetcher.sink.add(Color.fromARGB(255, 244, 67, 54));
          } else {
            final now = new DateTime.now();
            final difference = now.difference(this.lastSeen);
            if (difference > timeoutDuration) {
              _coloursFetcher.sink.add(Color.fromARGB(255, 158, 158, 158));
            } else {
              _coloursFetcher.sink.add(Color.fromARGB(255, 76, 175, 80));
            }
          }
        });
      });
    });
  }

  dispose() {
    _coloursFetcher.close();
  }
}
