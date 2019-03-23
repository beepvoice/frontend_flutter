import "package:flutter/material.dart";

import "../../blocs/bottom_bus_bloc.dart";
import "widgets/conversation_inactive_view.dart";
import "widgets/conversation_active_view.dart";

class BottomBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomBarState();
  }
}

class _BottomBarState extends State<BottomBar> {
  final bloc = bottomBusBloc;

  @override
  void dispose() {
    // bloc.dispose();
    super.dispose();
  }

  Widget getWidgetForState(Map<String, String> message) {
    if (message["state"] == "no_connection") {
      return ConversationInactiveView();
    } else if (message["state"] == "connection") {
      return ConversationActiveView(conversationName: message["title"]);
    } else {
      return ConversationInactiveView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Material(
        type: MaterialType.canvas,
        elevation: 10.0,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
        child: Container(
            padding: EdgeInsets.only(
                top: 20.0,
                left: 20.0,
                right: 20.0,
                bottom: 30.0 + bottomPadding),
            child: StreamBuilder(
                stream: bloc.bus,
                builder:
                    (context, AsyncSnapshot<Map<String, String>> snapshot) {
                  if (snapshot.hasData) {
                    return getWidgetForState(snapshot.data);
                  } else {
                    final message = bloc.lastMessage;
                    return getWidgetForState(message);
                  }
                })));
  }
}