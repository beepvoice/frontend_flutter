import "package:flutter/material.dart";
import "package:frontend_flutter/widgets/user_avatar/index.dart";

class ConversationItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      onTap: () => {},
      title:
          Text("Family Chat", style: Theme.of(context).primaryTextTheme.title),
      subtitle: Text("Mum I might have forgotten to close the windows",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).primaryTextTheme.subtitle),
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
                  Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                      child: UserAvatar(active: true, name: "IT")),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                      child: UserAvatar(active: true, name: "AM")),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                      child: UserAvatar(active: false, name: "SU")),
                ])
          ]),
    );
  }
}
