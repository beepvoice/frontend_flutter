import "package:flutter/material.dart";

import "../../models/user_model.dart";
import "../widgets/user_avatar.dart";

class ContactItem extends StatelessWidget {
  final User user;

  ContactItem({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              UserAvatar(
                  user: user,
                  radius: 18.0,
                  padding: EdgeInsets.only(left: 15.0)),
              Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(user.firstName + " " + user.lastName,
                            style: Theme.of(context).textTheme.title,
                            overflow: TextOverflow.ellipsis),
                        Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Text("Last seen x ago",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle
                                    .copyWith(color: Color(0xFF455A64)))),
                      ]))
            ]));
  }
}
