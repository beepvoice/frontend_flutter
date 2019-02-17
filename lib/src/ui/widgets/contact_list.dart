import "package:flutter/material.dart";

import "../../models/user_model.dart";
import "../../blocs/contact_bloc.dart";

import "contact_item.dart";

class ContactList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactListState();
  }
}

class _ContactListState extends State<ContactList> {
  final bloc = ContactBloc();

  @override
  void initState() {
    super.initState();
    bloc.fetchContacts();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.contacts,
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
    return ListView.builder(
      padding: EdgeInsets.only(top: 0.0),
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        return ContactItem(user: snapshot.data[index]);
      },
    );
  }
}
