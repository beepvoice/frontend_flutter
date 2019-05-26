import "package:flutter/material.dart";

import "widgets/conversation_inactive_view.dart";
import "widgets/conversation_active_view.dart";

class BottomBar extends StatelessWidget {
  final String conversationId;

  BottomBar({this.conversationId});

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
              top: 20.0, left: 20.0, right: 20.0, bottom: 30.0 + bottomPadding),
          child: (conversationId == "")
              ? ConversationInactiveView()
              : ConversationActiveView(conversationId: conversationId),
        ));
  }
}
