import "package:flutter/material.dart";

import "../../../models/conversation_model.dart";
import "../../../blocs/conversation_bloc.dart";

import "../../widgets/conversation_item.dart";
import "../../widgets/top_bar.dart";
import "../../widgets/search_input.dart";
import "../../widgets/small_text_button.dart";

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
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
    return Column(children: <Widget>[
      TopBar(
          title: "Conversations",
          search: SearchInput(
              controller: searchController, hintText: "Search for people"),
          children: <Widget>[
            SmallTextButton(
                text: "Edit",
                onClickCallback: () {
                  print("hello");
                }),
            Spacer(),
            IconButton(
                icon: Icon(Icons.add_comment),
                onPressed: () {
                  Navigator.pushNamed(context, "conversation/new");
                }),
          ]),
      Expanded(
          child:
              ListView(padding: EdgeInsets.only(top: 10.0), children: <Widget>[
        StreamBuilder(
            stream: conversationsBloc.conversations,
            builder: (context, AsyncSnapshot<List<Conversation>> snapshot) {
              if (snapshot.hasData) {
                return buildList(snapshot.data);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            })
      ]))
    ]);
  }

  Widget buildList(List<Conversation> data) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 0.0),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ConversationItem(conversation: data[index]);
      },
    );
  }
}
