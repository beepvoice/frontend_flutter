import "package:flutter/material.dart";

import "search_input.dart";

class TopBar extends StatelessWidget {
  final int state;
  final String logo = "assets/logo.png";
  final List<String> titleList = ["Contacts", "Conversations", "Settings"];

  TopBar({@required this.state});

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return Material(
        type: MaterialType.canvas,
        elevation: 5.0,
        child: Container(
          padding: EdgeInsets.only(top: statusbarHeight, bottom: 0),
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
                                .title
                                .copyWith(fontWeight: FontWeight.w300))),
                    Spacer(),
                    Text(titleList[state],
                        style: Theme.of(context).accentTextTheme.display1),
                    Spacer(),
                    (state == 1)
                        ? IconButton(
                            icon: Icon(Icons.add_comment), onPressed: () {})
                        : Container(),
                    (state == 0)
                        ? IconButton(icon: Icon(Icons.add), onPressed: () {})
                        : Container(),
                    (state == 2)
                        ? Opacity(
                            opacity: 0.0,
                            child: IconButton(
                                icon: Icon(Icons.edit), onPressed: () {}))
                        : Container(),
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
