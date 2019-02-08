import 'package:flutter/material.dart';
import 'package:frontend_flutter/widgets/app_bar/index.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      AppBar("BeepApp"),
      Container(child: Text("Hello World"))
    ]);
  }
}
