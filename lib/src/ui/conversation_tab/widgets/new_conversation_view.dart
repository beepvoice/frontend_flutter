import "package:flutter/material.dart";
import 'package:sticky_headers/sticky_headers.dart';

import "../../../models/user_model.dart";
import "../../../blocs/contact_bloc.dart";
import "../../../resources/conversation_api_provider.dart";

import "../../widgets/contact_item.dart";
import "../../widgets/top_bar.dart";
import "../../widgets/search_input.dart";
import "../../widgets/list_button.dart";

class NewConversationView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewConversationViewState();
  }
}

class _NewConversationViewState extends State<NewConversationView> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    contactBloc.fetchContacts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TopBar(
          title: "New Conversation",
          search: SearchInput(
              controller: searchController, hintText: "Search for people"),
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
            Spacer(),
          ]),
      Expanded(
          child: StreamBuilder(
              stream: contactBloc.contacts,
              builder: (context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.hasData) {
                  return buildList(snapshot);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              }))
    ]);
  }

  Widget buildList(AsyncSnapshot<List<User>> snapshot) {
    final Map<String, List<User>> sortedList = {
      "A": null,
      "B": null,
      "C": null,
      "D": null,
      "E": null,
      "F": null,
      "G": null,
      "H": null,
      "I": null,
      "J": null,
      "K": null,
      "L": null,
      "M": null,
      "N": null,
      "O": null,
      "P": null,
      "Q": null,
      "R": null,
      "S": null,
      "T": null,
      "U": null,
      "V": null,
      "W": null,
      "X": null,
      "Y": null,
      "Z": null
    };

    // Sort the list into alphabets
    sortedList.forEach((letter, list) {
      sortedList[letter] = snapshot.data
          .where((user) => user.firstName.startsWith(letter))
          .toList();
    });

    // Create list of children
    final children = sortedList.entries.map<Widget>((entry) {
      if (entry.value.length == 0) {
        return Container();
      }

      return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        StickyHeader(
            header: Container(
              height: 21.0,
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              alignment: Alignment.centerLeft,
              child: Text(entry.key,
                  style: Theme.of(context)
                      .primaryTextTheme
                      .display1
                      .copyWith(color: Theme.of(context).primaryColorDark)),
            ),
            content: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 0.0),
                shrinkWrap: true,
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  return ContactItem(
                      user: entry.value[index],
                      onClickCallback: (state) async {
                        final conversation = await conversationApiProvider
                            .createConversation("", dm: true);
                        await conversationApiProvider.createConversationMember(
                            conversation.id, entry.value[index].id);
                        Navigator.pushNamed(context, "conversation/home");
                      });
                }))
      ]);
    }).toList();

    children.insertAll(0, [
      ListButton(
          icon: Icons.group_add,
          text: "New Group",
          onClickCallback: () {
            Navigator.pushNamed(context, "conversation/new/group");
          }),
    ]);

    return ListView(padding: EdgeInsets.only(top: 0.0), children: children);
  }
}
