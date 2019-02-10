import 'package:flutter/material.dart';

import 'screens/home/index.dart';
import 'themer.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/home': (BuildContext context) => Container(child: Home()),
  };

  final theme = buildTheme();

  Routes() {
    runApp(MaterialApp(
      title: "Beep",
      theme: theme,
      routes: routes,
      home: Container(child: Home()),
    ));
  }
}
