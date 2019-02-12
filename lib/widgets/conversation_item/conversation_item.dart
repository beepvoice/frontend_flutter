import "package:flutter/material.dart";
import "package:frontend_flutter/widgets/user_avatar/index.dart";

class ConversationItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      onTap: () => {},
      contentPadding:
          EdgeInsets.only(top: 3.0, left: 20.0, right: 20.0, bottom: 3.0),
      title: Text("Family Chat", style: Theme.of(context).textTheme.title),
      subtitle: Text("Mum I might have forgotten to close the windows",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle),
      trailing: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text("1m ago",
                style: Theme.of(context).primaryTextTheme.body1.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark)),
            Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  UserAvatar(
                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                      active: true,
                      name: "IT"),
                  UserAvatar(
                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                      active: true,
                      name: "AM"),
                  UserAvatar(
                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                      active: false,
                      name: "SU"),
                ])
          ]),
    );
  }
}
