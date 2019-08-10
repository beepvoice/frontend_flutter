import "package:flutter/material.dart";

import "./widgets/home_view.dart";

class SettingsTab extends StatefulWidget {
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
            builder = (BuildContext _) => HomeView();
            break;
          // case "settings/profile_pic":
          //   builder = (BuildContext _) => NewsettingsView();
          //   break;
          // case "settings/new/group":
          //   builder = (BuildContext _) => NewGroupView();
          //   break;
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
