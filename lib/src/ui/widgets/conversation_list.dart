import "package:flutter/material.dart";

import "../../models/conversation_model.dart";
import "../../blocs/conversation_bloc.dart";

import "conversation_item.dart";

class ConversationList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConversationListState();
  }
}

class _ConversationListState extends State<ConversationList> {
  final bloc = ConversationsBloc();

  @override
  initState() {
    super.initState();
    bloc.fetchConversations();
  }

  @override
  dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.conversations,
        builder: (context, AsyncSnapshot<List<Conversation>> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot.data);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        });
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
