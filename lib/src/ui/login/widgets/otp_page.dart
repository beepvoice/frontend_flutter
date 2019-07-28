import "package:flutter/material.dart";
import 'package:pin_code_text_field/pin_code_text_field.dart';
import "package:flutter_svg/flutter_svg.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

import "../../../services/conversation_manager.dart";
import "../../../services/login_manager.dart";

import "../../widgets/text_button.dart";

// Callback types
typedef void HomeCallback();

class OtpPage extends StatefulWidget {
  final HomeCallback homeCallback;
  final LoginManager loginManager;

  OtpPage({@required this.loginManager, @required this.homeCallback});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final String phoneSvg = "assets/authenticate.svg";
  final controller = TextEditingController();
  bool isLoading = false;

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
                Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                        "I've sent an authentication code via SMS to your device, enter it below.",
                        style: Theme.of(context).accentTextTheme.title)),
                Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(
                        child: PinCodeTextField(
                            controller: controller,
                            maxLength: 6,
                            highlight: true,
                            autofocus: true,
                            highlightColor: Colors.white,
                            onTextChanged: (text) {},
                            onDone: (text) async {
                              await processOtp();
                            },
                            pinBoxHeight:
                                (MediaQuery.of(context).size.width / 6) - 15,
                            pinBoxWidth:
                                (MediaQuery.of(context).size.width / 6) - 15,
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
          (!isLoading)
              ? TextButton(
                  text: "Done",
                  onClickCallback: () async {
                    await processOtp();
                  })
              : Center(
                  child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 40.0,
                )),
        ]));
  }

  processOtp() async {
    setState(() => isLoading = true);
    final authToken = await widget.loginManager.processOtp(controller.text);
    final user = await widget.loginManager.getUser();

    await ConversationManager.init(authToken);
    if (user.firstName == "" && user.lastName == "") {
      Navigator.pushNamed(context, 'welcome/register');
    } else {
      widget.homeCallback();
    }
  }
}
