import "package:flutter/material.dart";

import "../../../models/user_model.dart";
import "../../widgets/user_avatar.dart";

class ContactItem extends StatelessWidget {
  final User user;

  ContactItem({@required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding:
            EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
        leading: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          /*Icon(Icons.star, color: Theme.of(context).primaryColorDark),*/
          Text("A",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColorDark)),
          UserAvatar(
              user: user, radius: 22.0, padding: EdgeInsets.only(left: 20.0))
        ]),
        title: Text(user.firstName + " " + user.lastName,
            style: Theme.of(context).textTheme.display2,
            overflow: TextOverflow.ellipsis),
        subtitle: Text("Last seen just now",
            style: Theme.of(context).textTheme.subtitle),
        onTap: () => {});
  }
}
