import "package:flutter/material.dart";

import "../../../models/conversation_model.dart";
import "../../../blocs/conversation_bloc.dart";

import "conversation_item.dart";

class ConversationList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConversationListState();
  }
}

class _ConversationListState extends State<ConversationList> {
  @override
  initState() {
    super.initState();
    conversationsBloc.fetchConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: StreamBuilder(
            stream: conversationsBloc.conversations,
            builder: (context, AsyncSnapshot<List<Conversation>> snapshot) {
              if (snapshot.hasData) {
                return buildList(snapshot.data);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  Widget buildList(List<Conversation> data) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 0.0),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ConversationItem(conversation: data[index]);
      },
    );
  }
}
