import 'package:flutter/material.dart';

import 'src/ui/home/home.dart';
import "src/ui/login/welcome.dart";
import "src/services/login_manager.dart";
import 'themer.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/home': (BuildContext context) => Container(child: Home()),
    '/welcome': (BuildContext context) => Welcome(),
  };

  final theme = buildTheme();
  final loginManager = LoginManager();

  Routes() {
    checkIfLogin();
  }

  checkIfLogin() async {
    final authToken = await loginManager.getToken();
    print(authToken);

    if (authToken != "") {
      runApp(MaterialApp(
        title: "Beep",
        theme: theme,
        routes: routes,
        home: Home(),
      ));
    } else {
      runApp(MaterialApp(
        title: "Beep",
        theme: theme,
        routes: routes,
        home: Welcome(),
      ));
    }
  }
}
