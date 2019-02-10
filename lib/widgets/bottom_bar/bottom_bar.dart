import "package:flutter/material.dart";

class BottomBar extends StatelessWidget {
  final double barHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.canvas,
        elevation: 10.0,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
        child: Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 20.0),
                      width: 22.0,
                      height: 22.0,
                      decoration: BoxDecoration(
                          color: Theme.of(context).indicatorColor,
                          shape: BoxShape.circle)),
                  Text("Family Chat",
                      style: Theme.of(context)
                          .textTheme
                          .display1
                          .copyWith(color: Theme.of(context).accentColor)),
                  Spacer(),
                  IconButton(
                      color: Theme.of(context).accentColor,
                      icon: Icon(Icons.info),
                      onPressed: () {
                        print("Pressed");
                      }),
                  IconButton(
                      color: Theme.of(context).accentColor,
                      icon: Icon(Icons.close),
                      onPressed: () {
                        print("Pressed");
                      }),
                ])));
  }
}
