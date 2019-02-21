import "package:flutter/material.dart";

class LoginCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
        height: (MediaQuery.of(context).size.height / 2) + 50,
        child: Card(
          elevation: 10.0,
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text("Phone number",
                    style: Theme.of(context)
                        .textTheme
                        .display3
                        .copyWith(fontSize: 20.0)),
                TextField(),
              ])),
        ));
  }
}
