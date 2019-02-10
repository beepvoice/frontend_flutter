import "package:flutter/material.dart";

import "package:frontend_flutter/widgets/top_bar/index.dart";
import "package:frontend_flutter/widgets/conversation_list/index.dart";
import "package:frontend_flutter/widgets/bottom_bar/index.dart";

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
          TopBar("Conversations"),
          Expanded(
              child: ConversationList(
                  items: List<String>.generate(100, (i) => "Item $i"))),
        ]),
        bottomSheet: BottomBar());
  }
}
