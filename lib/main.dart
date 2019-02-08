import 'package:flutter/material.dart';
import './appbar.dart';

void main() => runApp(BeepApp());

class BeepApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      AppBar("BeepApp"),
      Container(child: Text("Hello World"))
    ]);
  }
}
