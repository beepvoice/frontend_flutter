import "package:flutter/material.dart";

class Welcome extends StatelessWidget {
  final String logo = "assets/logo.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
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
            Text("Welcome!", style: Theme.of(context).accentTextTheme.display4),
            Text("Let's get you set up",
                style: Theme.of(context).accentTextTheme.display2),
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
