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
              backgroundColor: Colors.brown.shade800,
              child: Text(user.firstName[0] + user.lastName[0]),
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
}
