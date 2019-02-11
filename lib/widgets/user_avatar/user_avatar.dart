import "package:flutter/material.dart";

class UserAvatar extends StatelessWidget {
  final bool active;
  final String name;
  final EdgeInsetsGeometry padding;

  UserAvatar({this.active, this.name, this.padding: const EdgeInsets.all(0.0)});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: Stack(alignment: Alignment.bottomRight, children: <Widget>[
          CircleAvatar(
              backgroundColor: Colors.brown.shade800, child: Text(name)),
          active
              ? Container(
                  width: 12.0,
                  height: 12.0,
                  decoration: BoxDecoration(
                      color: Theme.of(context).indicatorColor,
                      shape: BoxShape.circle))
              : Container(),
        ]));
  }
}
