import "package:flutter/material.dart";

import "search_input.dart";

class TopBar extends StatelessWidget {
  final String logo = "assets/logo.png";
  final List<Widget> children;
  final String title;

  TopBar({@required this.children, @required this.title});

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
            child: Stack(alignment: Alignment.center, children: [
              Text(title, style: Theme.of(context).accentTextTheme.display1),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              )
            ]),
          ),
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
