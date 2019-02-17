import "package:flutter/material.dart";

import "../../models/user_model.dart";

class UserAvatar extends StatelessWidget {
  final User user;
  final EdgeInsetsGeometry padding;
  final double radius;

  UserAvatar(
      {@required this.user,
      this.padding: const EdgeInsets.all(0.0),
      this.radius: 20.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: Stack(alignment: Alignment.bottomRight, children: <Widget>[
          CircleAvatar(
              backgroundColor: _stringToColor(user.lastName),
              child: Text(
                user.firstName[0].toUpperCase() +
                    user.lastName[0].toUpperCase(),
                style: Theme.of(context).accentTextTheme.title,
              ),
              radius: radius),
          /*active
              ? Container(
                  width: 12.0,
                  height: 12.0,
                  decoration: BoxDecoration(
                      color: Theme.of(context).indicatorColor,
                      shape: BoxShape.circle))
              : Container(),*/
        ]));
  }

  // Hashing username into a pastel color
  Color _stringToColor(String str) {
    int hash = 0;

    str.runes.forEach((int rune) {
      hash = rune + ((hash << 5) - hash);
    });

    hash = hash % 360;

    return HSLColor.fromAHSL(1.0, hash.toDouble(), 0.8, 0.4).toColor();
  }
}
