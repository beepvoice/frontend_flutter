import "dart:async";
import "dart:convert";
import "dart:core";
import "dart:ui";

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

  final _coloursFetcher = PublishSubject<Color>();

  final http.Client client;
  Observable<Color> get colours => _coloursFetcher.stream;

  HeartbeatReceiverBloc(String userId) : client = http.Client() {
    this.userId = userId;
    lastSeen = DateTime.fromMillisecondsSinceEpoch(0);
    status = "";

    loginManager.getToken().then((token) {
      print(token);
      EventSource.connect("$baseUrlHeartbeat/subscribe/$userId?token=$token",
              client: client)
          .then((es) {
        es.listen((Event event) {
          print(event.data);
          Ping ping = Ping.fromJson(jsonDecode(event.data));
          print(ping.timestamp);
          // lastSeen = DateTime.fromMillisecondsSinceEpoch(ping.timestamp);
          // status = ping.status;
        });
        print("GOT SEND");
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
      }).catchError((e) => print(
              e)); // Add actual error handling logic for stopped connections
    });
  }

  dispose() {
    print("Destroying bloc");
    _coloursFetcher.close();
    client.close();
  }
}
