import "package:flutter/material.dart";

import "../../../models/conversation_model.dart";
import "../../../blocs/conversation_bloc.dart";

import "../../widgets/conversation_item.dart";
import "../../widgets/top_bar.dart";
import "../../widgets/search_input.dart";

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
      TopBar(title: "Conversations", children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 13.0),
            child: Text("Edit",
                style: Theme.of(context)
                    .accentTextTheme
                    .title
                    .copyWith(fontWeight: FontWeight.w300))),
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
        Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
            child: SearchInput(
                controller: searchController,
                hintText: "Search for messages or users")),
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
