import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../widgets/text_button.dart";
import "../widgets/welcome_card.dart";

class Welcome extends StatelessWidget {
  final String logo = "assets/logo.png";
  final String joinSvg = "assets/join.svg";

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
          top: topPadding + 10.0,
          bottom: bottomPadding + 10.0,
          left: 10.0,
          right: 10.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Image.asset(logo,
                  semanticLabel: "Beep logo", width: 30.0, height: 50.0),
              Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Beep",
                      style: Theme.of(context).accentTextTheme.display3)),
            ]),
            Spacer(),
            Text("Hi, there.",
                style: Theme.of(context).accentTextTheme.display4),
            Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text("Let's get you set up and ready to go!",
                    style: Theme.of(context).accentTextTheme.title,
                    textAlign: TextAlign.center)),
            TextButton(text: "Start", onClickCallback: () => print("hello")),
          ]),
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
