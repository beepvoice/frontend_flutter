import "package:flutter/material.dart";

import "./widgets/home_view.dart";
import "../../blocs/message_bloc.dart";

class ContactTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactTabState();
  }
}

class _ContactTabState extends State<ContactTab> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: "contact/home",
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case "contact/home":
            builder = (BuildContext _) => HomeView();
            break;
          case "contact/new":
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
