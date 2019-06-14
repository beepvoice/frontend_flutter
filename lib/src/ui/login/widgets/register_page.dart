import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../../widgets/text_button.dart";
import "../../../services/login_manager.dart";
import "../../../resources/user_api_provider.dart";

import "phone_input.dart";
import "input.dart";

class RegisterPage extends StatefulWidget {
  final LoginManager loginManager;

  RegisterPage({@required this.loginManager});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final String phoneSvg = "assets/phoneno.svg";

  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final userApiProvider = UserApiProvider();

  @override
  void dispose() {
    phoneController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: SvgPicture.asset(phoneSvg,
                    height: MediaQuery.of(context).size.height / 5)),
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Let's get you going.",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).accentTextTheme.display3),
                  Text("Enter your info to create your very own Beep account.",
                      style: Theme.of(context)
                          .accentTextTheme
                          .title
                          .copyWith(fontWeight: FontWeight.w400)),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Input(
                          controller: firstNameController,
                          hintText: "First name")),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Input(
                          controller: lastNameController,
                          hintText: "Last name")),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: PhoneInput(controller: phoneController)),
                ])
          ]))),
          Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: TextButton(
                  text: "Continue",
                  onClickCallback: () async {
                    final firstName = firstNameController.text;
                    final lastName = lastNameController.text;
                    final phoneNumber = "+65${phoneController.text}";

                    // Creating the new user
                    await userApiProvider.registerUser(
                        firstName, lastName, phoneNumber);
                    await widget.loginManager
                        .initAuthentication("+65$phoneNumber");
                    Navigator.pushNamed(context, 'welcome/otp');
                  })),
        ]));
  }
}
