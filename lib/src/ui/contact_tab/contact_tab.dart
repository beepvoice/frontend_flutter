import "package:flutter/material.dart";

import "./widgets/home_view.dart";

class ContactTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactTabState();
  }
}

class _ContactTabState extends State<ContactTab> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: "conversation/home",
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case "conversation/home":
            builder = (BuildContext _) => HomeView();
            break;
          case "conversation/new":
            builder = (BuildContext _) => Center(child: Text("SOON"));
            break;
          default:
            throw Exception("Invalid route: ${settings.name}");
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
