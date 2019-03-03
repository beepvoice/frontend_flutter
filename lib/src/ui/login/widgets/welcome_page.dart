import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../../widgets/text_button.dart";

class WelcomePage extends StatelessWidget {
  final String welcomeSvg = "assets/welcome.svg";

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
          TextButton(text: "Sign Up", onClickCallback: () => print("hello")),
        ]));
  }
}
