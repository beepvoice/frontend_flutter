import "package:flutter/material.dart";

import "../../../models/conversation_model.dart";
import "../../../blocs/conversation_bloc.dart";

import "conversation_item.dart";
import "search_input.dart";

class ConversationView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConversationViewState();
  }
}

class _ConversationViewState extends State<ConversationView> {
  final searchController = TextEditingController();

  @override
  initState() {
    super.initState();
    conversationsBloc.fetchConversations();
  }

  @override
  dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              child: SearchInput(
                  controller: searchController,
                  hintText: "Search for messages or users")),
          Flexible(
              child: StreamBuilder(
                  stream: conversationsBloc.conversations,
                  builder:
                      (context, AsyncSnapshot<List<Conversation>> snapshot) {
                    if (snapshot.hasData) {
                      return buildList(snapshot.data);
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return Center(child: CircularProgressIndicator());
                  }))
        ]));
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
