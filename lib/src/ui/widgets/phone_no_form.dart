import "package:flutter/material.dart";
import "phone_input.dart";

class PhoneNumberForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
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
                Padding(
                    padding: EdgeInsets.only(top: 20.0), child: PhoneInput()),
              ])),
    );
  }
}
