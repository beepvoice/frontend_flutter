import 'package:flutter/material.dart';
import 'screens/home/index.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/home': (BuildContext context) => Home()
  };

  Routes() {
    runApp(MaterialApp(
      title: "Beep",
      routes: routes,
      home: Home(),
    ));
  }
}
