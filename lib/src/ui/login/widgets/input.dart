import "package:flutter/material.dart";

class Input extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  Input({@required this.controller, @required this.hintText});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Expanded(
              child: TextField(
                  controller: controller,
                  autocorrect: false,
                  cursorWidth: 2.0,
                  cursorColor: Colors.white,
                  style: Theme.of(context).accentTextTheme.title,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0x10000000),
                    hintText: hintText,
                    hintStyle: Theme.of(context).accentTextTheme.title,
                  ))),
        ]));
  }
}
