import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../../widgets/text_button.dart";

class WelcomePage extends StatelessWidget {
  final String welcomeSvg = "assets/welcome.svg";
  final String logo = "assets/logo.png";

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Image.asset(logo,
                semanticLabel: "Beep logo", width: 30.0, height: 50.0),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text("Beep",
                    style: Theme.of(context).accentTextTheme.display3)),
          ]),
          Spacer(),
          SvgPicture.asset(welcomeSvg,
              width: MediaQuery.of(context).size.width - 40.0),
          Spacer(),
          Text("Hi, there.", style: Theme.of(context).accentTextTheme.display4),
          Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text("Let's get you set up and ready to go!",
                  style: Theme.of(context).accentTextTheme.title,
                  textAlign: TextAlign.center)),
          TextButton(
              text: "Login",
              onClickCallback: () =>
                  Navigator.pushNamed(context, "welcome/login")),
        ]));
  }
}
