import "package:flutter/material.dart";

import "./widgets/home_view.dart";
import "./widgets/new_conversation_view.dart";
import "./widgets/new_group_view.dart";
import "./widgets/new_group_info_view.dart";

import "../../models/user_model.dart";

class ConversationTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConversationTabState();
  }
}

class _ConversationTabState extends State<ConversationTab> {
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
            builder = (BuildContext _) => NewConversationView();
            break;
          case "conversation/new/group":
            builder = (BuildContext _) => NewGroupView();
            break;
          case "conversation/new/groupinfo":
            final List<User> users = settings.arguments;
            builder = (BuildContext _) => NewGroupInfoView(users: users);
            break;
          default:
            throw Exception("Invalid route: ${settings.name}");
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
