import "package:flutter/material.dart";

import "package:frontend_flutter/widgets/top_bar/index.dart";
import "package:frontend_flutter/widgets/conversation_list/index.dart";

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      TopBar("Conversations"),
      Expanded(
          child: ConversationList(
              items: List<String>.generate(3, (i) => "Item $i"))),
    ]));
  }
}
