import 'package:flutter/material.dart';

import 'src/ui/home/home.dart';
import "src/ui/login/welcome.dart";
import "src/ui/login/login.dart";
import "src/ui/login/otp.dart";
import 'themer.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/home': (BuildContext context) => Container(child: Home()),
    '/welcome': (BuildContext context) => Welcome(),
    '/login': (BuildContext context) => Login(),
    '/otp': (BuildContext context) => Otp(),
  };

  final theme = buildTheme();

  Routes() {
    runApp(MaterialApp(
      title: "Beep",
      theme: theme,
      routes: routes,
      home: Welcome(),
    ));
  }
}
