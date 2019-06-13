import "package:flutter/material.dart";

import "search_input.dart";

class TopBar extends StatelessWidget {
  final String title;
  final String logo = "assets/logo.png";

  TopBar({@required this.title});

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return Material(
        type: MaterialType.canvas,
        elevation: 5.0,
        child: Container(
          padding: EdgeInsets.only(top: statusbarHeight, bottom: 2.0),
          child: Material(
              type: MaterialType.transparency,
              elevation: 0.0,
              color: Colors.transparent,
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 13.0),
                        child: Text("Edit",
                            style: Theme.of(context)
                                .accentTextTheme
                                .display2
                                .copyWith(fontWeight: FontWeight.w400))),
                    Spacer(),
                    Text(title,
                        style: Theme.of(context).accentTextTheme.display1),
                    Spacer(),
                    IconButton(icon: Icon(Icons.add_comment), onPressed: () {})
                  ],
                ),
              ])),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorDark
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ));
  }
}
