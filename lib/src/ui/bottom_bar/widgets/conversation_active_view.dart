import "package:flutter/material.dart";

import "../../widgets/user_avatar.dart";
import "../../../models/user_model.dart";
import "../../../blocs/bottom_bus_bloc.dart";

class ConversationActiveView extends StatelessWidget {
  final String conversationName;
  final bus = bottomBusBloc;

  ConversationActiveView({@required this.conversationName});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 22.0,
                height: 22.0,
                decoration: BoxDecoration(
                    color: Theme.of(context).indicatorColor,
                    shape: BoxShape.circle)),
            Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Text(conversationName,
                    style: Theme.of(context)
                        .textTheme
                        .display1
                        .copyWith(color: Theme.of(context).accentColor))),
            Spacer(),
            IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.info),
                onPressed: () {
                  print("Pressed info");
                }),
            IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.close),
                onPressed: () {
                  // Call method to close connection
                  bus.publish({"state": "no_connection"});
                  print("Pressed close");
                }),
          ]),
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            UserAvatar(
                padding: EdgeInsets.only(right: 5.0),
                user: User("1", "Isaac", "Tay", "+65 91043593")),
            UserAvatar(
                padding: EdgeInsets.only(right: 5.0),
                user: User("1", "Isaac", "Tay", "+65 91043593")),
            UserAvatar(
                padding: EdgeInsets.only(right: 5.0),
                user: User("1", "Rui", "Juidfsdf", "+65 91043593"))
          ]),
    ]));
  }
}
