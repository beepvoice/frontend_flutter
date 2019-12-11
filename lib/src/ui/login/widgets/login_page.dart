import 'dart:io';

import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

import "../../widgets/text_button.dart";
import "../../../services/login_manager.dart";
import "../../../../settings.dart";
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
  bool _isLoading = false;
  String _errorText = "";

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
                  Text("First things first.",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).accentTextTheme.display3),
                  Text(
                      "Enter your phone number, to connect to your Beep account.",
                      style: Theme.of(context)
                          .accentTextTheme
                          .title
                          .copyWith(fontWeight: FontWeight.w400)),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: PhoneInput(controller: controller)),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                          _errorText,
                          style: Theme.of(context).textTheme.display1.copyWith(
                              fontSize: 15.0, 
                              color: Color(0xFFFFFFFF)))),
                ])
          ]))),
          Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: (!_isLoading)
                  ? TextButton(
                      text: "Continue",
                      onClickCallback: () async {
                        await _processPhoneNumber();
                      })
                  : Center(
                      child: SpinKitThreeBounce(
                      color: Colors.white,
                      size: 40.0,
                    ))),
        ]));
  }

  _processPhoneNumber() async {
    setState(() {
      _isLoading = true;
      _errorText = "";
    });
    try {
      if (BYPASS_AUTH) {
        await widget.loginManager.initAuthenticationBypass("+65${controller.text}");
      } else {
        await widget.loginManager.initAuthentication("+65${controller.text}");
      }
      Navigator.pushNamed(context, 'welcome/otp');
    } on HttpException catch (e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
        _errorText = "Error processing phone number. Please try again.";
      });
    } on Exception catch (e) {
      print("Unknown exception: $e");
    }
  }
}
