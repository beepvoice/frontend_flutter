import "package:flutter/material.dart";
import 'package:frontend_flutter/src/ui/settings_tab/widgets/data_usage_view.dart';
import 'package:frontend_flutter/src/ui/settings_tab/widgets/interface_view.dart';
import 'package:frontend_flutter/src/ui/settings_tab/widgets/notifications_view.dart';
import 'package:frontend_flutter/src/ui/settings_tab/widgets/privacy_security_view.dart';

import "./widgets/home_view.dart";

class SettingsTab extends StatefulWidget {
  final VoidCallback toWelcomePage;

  SettingsTab({@required this.toWelcomePage});

  @override
  State<StatefulWidget> createState() {
    return _SettingsTabState();
  }
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: "settings/home",
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case "settings/home":
            builder = (BuildContext _) =>
                HomeView(toWelcomePage: widget.toWelcomePage);
            break;
          case "settings/interface":
            builder = (BuildContext _) => InterfaceView();
            break;
          case "settings/notifications":
            builder = (BuildContext _) => NotificationsView();
            break;
          case "settings/privacy_security":
            builder = (BuildContext _) => PrivacySecurityView();
            break;
          case "settings/data_usage":
            builder = (BuildContext _) => DataUsageView();
            break;
          // case "settings/new/groupinfo":
          //   final List<User> users = settings.arguments;
          //   builder = (BuildContext _) => NewGroupInfoView(users: users);
          //   break;
          default:
            throw Exception("Invalid route: ${settings.name}");
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
