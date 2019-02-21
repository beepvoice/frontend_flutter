import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class WelcomeCard extends StatelessWidget {
  final String assetString;
  final String text;

  WelcomeCard({@required this.assetString, @required this.text});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 10;

    return Padding(
        padding:
            EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(assetString, height: 200),
              Spacer(),
              Text(text,
                  style: Theme.of(context)
                      .textTheme
                      .display1
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center),
            ]));
  }
}
