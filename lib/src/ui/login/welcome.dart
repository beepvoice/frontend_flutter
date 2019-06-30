import "package:flutter/material.dart";

import "../../services/login_manager.dart";
import "../../services/conversation_manager.dart";
import "./widgets/welcome_page.dart";
import "./widgets/login_page.dart";
import "./widgets/otp_page.dart";
import "./widgets/register_page.dart";

class Welcome extends StatelessWidget {
  final String logo = "assets/logo.png";
  final LoginManager loginManager = LoginManager();
  final Map<String, String> user = {};

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: bottomPadding + 10.0,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Navigator(
              initialRoute: "welcome/hello",
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                switch (settings.name) {
                  case "welcome/hello":
                    builder = (BuildContext _) => WelcomePage();
                    break;
                  case "welcome/register":
                    builder = (BuildContext _) =>
                        RegisterPage(loginManager: loginManager);
                    break;
                  case "welcome/login":
                    builder = (BuildContext _) =>
                        LoginPage(loginManager: loginManager);
                    break;
                  case "welcome/otp":
                    builder = (BuildContext _) =>
                        OtpPage(buttonCallback: (String otp) async {
                          final authToken = await loginManager.processOtp(otp);
                          final user = await loginManager.getUser();

                          await ConversationManager.init(authToken);
                          if (user.firstName == "" && user.lastName == "") {
                              Navigator.pushNamed(context, 'welcome/register');
                          } else {
                              Navigator.of(context).pushReplacementNamed("/home");
                          }
                        });
                    break;
                  default:
                    throw Exception("Invalid route: ${settings.name}");
                }
                return MaterialPageRoute(builder: builder, settings: settings);
              },
            )),
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
    ));
  }
}
