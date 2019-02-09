import "package:flutter/material.dart";

class UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomRight, children: <Widget>[
      CircleAvatar(backgroundColor: Colors.brown.shade800, child: Text("AH")),
      Container(
          width: 12.0,
          height: 12.0,
          decoration: BoxDecoration(
              color: Theme.of(context).indicatorColor, shape: BoxShape.circle)),
    ]);
  }
}
