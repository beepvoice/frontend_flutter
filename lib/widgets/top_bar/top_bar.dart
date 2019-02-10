import "package:flutter/material.dart";

class TopBar extends StatelessWidget {
  final String title;
  final double barHeight = 100.0;
  final String logo = "assets/logo.png";

  TopBar(title) : title = title;

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    // TODO: Fix cropping by moving onto stack, refactor widget into smaller parts
    return Material(
        type: MaterialType.canvas,
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.only(top: statusbarHeight, bottom: 10.0),
          child: Material(
              type: MaterialType.transparency,
              elevation: 10.0,
              color: Colors.transparent,
              child: Column(children: <Widget>[
                Stack(alignment: Alignment.center, children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Image.asset(logo,
                              semanticLabel: "Beep Logo",
                              width: 24.0,
                              height: 24.0)),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            print("Pressed");
                          }),
                      IconButton(
                          icon: Icon(Icons.dehaze),
                          onPressed: () {
                            print("Pressed");
                          })
                    ],
                  ),
                  Positioned(
                      child: Text(title,
                          style: Theme.of(context).textTheme.display1)),
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Opacity(
                          opacity: 1.0,
                          child: Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Container(
                                  width: 5.0,
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle)))),
                      Opacity(
                          opacity: 0.6,
                          child: Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Container(
                                  width: 5.0,
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle)))),
                      Opacity(
                          opacity: 0.6,
                          child: Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Container(
                                  width: 5.0,
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle)))),
                    ]),
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
