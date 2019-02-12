import "package:flutter/material.dart";
import "package:frontend_flutter/widgets/user_avatar/index.dart";

class ContactItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding:
            EdgeInsets.only(top: 3.0, left: 20.0, right: 20.0, bottom: 3.0),
        leading: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          /*Icon(Icons.star, color: Theme.of(context).primaryColorDark),*/
          Text("A",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColorDark)),
          UserAvatar(
              active: true,
              name: "SU",
              radius: 22.0,
              padding: EdgeInsets.only(left: 20.0))
        ]),
        title: Text("Ambrose Chua",
            style: Theme.of(context).textTheme.display2,
            overflow: TextOverflow.ellipsis),
        onTap: () => {});
  }
}
