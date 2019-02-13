import "package:flutter/material.dart";

import "contact_item.dart";

class ContactList extends StatelessWidget {
  final List<String> items;

  ContactList({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 0.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ContactItem();
      },
    );
  }
}
