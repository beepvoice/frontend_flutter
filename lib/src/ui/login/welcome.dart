import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "./widgets/welcome_page.dart";
import "./widgets/login_page.dart";
import "./widgets/otp_page.dart";

class Welcome extends StatelessWidget {
  final String logo = "assets/logo.png";

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
          top: topPadding,
          bottom: bottomPadding + 10.0,
          left: 15.0,
          right: 15.0),
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
            Expanded(child: OtpPage()),
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
