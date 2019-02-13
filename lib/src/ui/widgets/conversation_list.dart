import "package:flutter/material.dart";

import "conversation_item.dart";

class ConversationList extends StatelessWidget {
  final List<String> items;

  ConversationList({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 0.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ConversationItem();
      },
    );
  }
}
