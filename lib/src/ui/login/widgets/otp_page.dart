import "package:flutter/material.dart";
import 'package:pin_code_text_field/pin_code_text_field.dart';
import "package:flutter_svg/flutter_svg.dart";

import "../../widgets/text_button.dart";

// Callback types
typedef void ButtonCallback();

class OtpPage extends StatelessWidget {
  final String phoneSvg = "assets/authenticate.svg";
  final ButtonCallback buttonCallback;

  OtpPage({@required this.buttonCallback});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: SvgPicture.asset(phoneSvg,
                  height: MediaQuery.of(context).size.height / 5)),
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Almost there.",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).accentTextTheme.display3),
                Text(
                    "I've sent an authentication code via SMS to your device, enter it below.",
                    style: Theme.of(context)
                        .accentTextTheme
                        .title
                        .copyWith(fontWeight: FontWeight.w400)),
                Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(
                        child: PinCodeTextField(
                            highlight: true,
                            highlightColor: Colors.white,
                            /*hideCharacter: true,*/
                            pinBoxDecoration: (Color color) {
                              return BoxDecoration(
                                  color: Color(0x10000000),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.00)));
                            },
                            pinTextStyle:
                                Theme.of(context).accentTextTheme.display3))),
              ]),
          Spacer(),
          TextButton(text: "Done", onClickCallback: () => buttonCallback()),
        ]));
  }
}