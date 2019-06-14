import "package:flutter/material.dart";
import 'package:sticky_headers/sticky_headers.dart';

import "../../../models/user_model.dart";
import "../../../blocs/contact_bloc.dart";

import "contact_item.dart";
import "search_input.dart";

class ContactView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactViewState();
  }
}

class _ContactViewState extends State<ContactView> {
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
    return StreamBuilder(
        stream: contactBloc.contacts,
        builder: (context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        });
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
              height: 25.0,
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              alignment: Alignment.centerLeft,
              child: Text(
                entry.key,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark),
              ),
            ),
            content: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 0.0),
                shrinkWrap: true,
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  return ContactItem(user: entry.value[index]);
                }))
      ]);
    }).toList();

    children.insertAll(0, [
      Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            SearchInput(
                controller: searchController, hintText: "Search for people"),
            Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(children: <Widget>[
                  Icon(Icons.people_outline,
                      color: Theme.of(context).primaryColorDark, size: 40.0),
                  Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text("Invite Friends",
                          style: Theme.of(context).textTheme.display1.copyWith(
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.w400))),
                ])),
          ])),
    ]);
    return ListView(padding: EdgeInsets.only(top: 10.0), children: children);
  }
}
