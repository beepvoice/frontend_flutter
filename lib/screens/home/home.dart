import 'package:flutter/material.dart';
import 'package:frontend_flutter/widgets/top_bar/index.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      TopBar("BeepApp"),
      Container(child: Text("Hello World"))
    ]));
  }
}
