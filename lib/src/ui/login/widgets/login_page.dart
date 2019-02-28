import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../../widgets/text_button.dart";
import "phone_input.dart";

class LoginPage extends StatelessWidget {
  final String phoneSvg = "assets/phoneno.svg";

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
          child: SvgPicture.asset(phoneSvg,
              height: MediaQuery.of(context).size.height / 5)),
      Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("First things first.",
                textAlign: TextAlign.left,
                style: Theme.of(context).accentTextTheme.display3),
            Text(
                "Enter your phone number, to connect to your existing Beep account.",
                style: Theme.of(context)
                    .accentTextTheme
                    .title
                    .copyWith(fontWeight: FontWeight.w400)),
            Padding(padding: EdgeInsets.only(top: 20.0), child: PhoneInput()),
          ]),
      Spacer(),
      TextButton(
          text: "Continue",
          onClickCallback: () => Navigator.pushNamed(context, '/otp')),
    ]);
  }
}
