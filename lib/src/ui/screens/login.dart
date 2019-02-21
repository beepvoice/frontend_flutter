import "package:flutter/material.dart";
import "../widgets/login_card.dart";
import "package:flutter_svg/flutter_svg.dart";

class Login extends StatelessWidget {
  final String logo = "assets/logo.png";
  final String phoneSvg = "assets/phoneno.svg";

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
        body: Stack(children: <Widget>[
      Column(children: <Widget>[
        Expanded(
            child: Container(
          padding: EdgeInsets.only(top: topPadding, bottom: 60),
          child: Column(children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(logo,
                      semanticLabel: "Beep logo", width: 30.0, height: 50.0),
                  Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text("Beep",
                          style: Theme.of(context).accentTextTheme.display3)),
                ]),
            Spacer(),
            SvgPicture.asset(phoneSvg,
                width: MediaQuery.of(context).size.width - 20),
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
        )),
        Expanded(child: Container())
      ]),
      Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[LoginCard()]),
    ]));
  }
}