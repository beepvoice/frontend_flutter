import "package:flutter/material.dart";
import "../widgets/text_button.dart";
import "../widgets/otp_form.dart";
import "package:flutter_svg/flutter_svg.dart";

class Otp extends StatelessWidget {
  final String logo = "assets/logo.png";
  final String phoneSvg = "assets/authenticate.svg";

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
            top: topPadding,
            bottom: bottomPadding + 10.0,
            left: 20.0,
            right: 20.0),
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
          Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: SvgPicture.asset(phoneSvg,
                  height: MediaQuery.of(context).size.height / 5)),
          OtpForm(),
          Spacer(),
          TextButton(
              text: "Done",
              onClickCallback: () => Navigator.pushNamed(context, '/home')),
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
      ),
    );
  }
}
