import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../../widgets/text_button.dart";
import "../../../services/login_manager.dart";
import "phone_input.dart";

class LoginPage extends StatefulWidget {
  final LoginManager loginManager;

  LoginPage({@required this.loginManager});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String phoneSvg = "assets/phoneno.svg";
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                    padding: EdgeInsets.only(top: 20.0),
                    child: PhoneInput(controller: controller)),
              ]),
          Spacer(),
          TextButton(
              text: "Continue",
              onClickCallback: () async {
                print(await widget.loginManager.getToken());
                await widget.loginManager
                    .initAuthentication("+65${controller.text}");
                Navigator.pushNamed(context, 'welcome/otp');
              }),
        ]));
  }
}
