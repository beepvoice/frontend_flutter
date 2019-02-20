import 'package:flutter/material.dart';

import 'src/ui/screens/home.dart';
import "src/ui/screens/welcome.dart";
import 'themer.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/home': (BuildContext context) => Container(child: Home()),
    '/welcome': (BuildContext context) => Welcome(),
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
