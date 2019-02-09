import "package:flutter/material.dart";

class TopBar extends StatelessWidget {
  final String title;
  final double barHeight = 50.0;

  TopBar(title) : title = title;

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusbarHeight, bottom: statusbarHeight),
      height: statusbarHeight * 2,
      child: Row(
        children: <Widget>[
          Text("Conversations", style: Theme.of(context).textTheme.display1)
        ],
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
    );
  }
}
