import "package:flutter/material.dart";

import "../../widgets/user_avatar.dart";
import "../../../resources/conversation_api_provider.dart";
import "../../../models/user_model.dart";
import "../../../models/conversation_model.dart";
import "../../../blocs/bottom_bus_bloc.dart";
import "../../../services/conversation_manager.dart";

class ConversationActiveView extends StatefulWidget {
  final String conversationId;

  ConversationActiveView({@required this.conversationId});

  @override
  State<StatefulWidget> createState() {
    return _ConversationActiveViewState();
  }
}

class _ConversationActiveViewState extends State<ConversationActiveView> {
  final bus = bottomBusBloc;
  final conversationApiProvider = ConversationApiProvider();
  final conversationManager = ConversationManager();
  Conversation conversation;

  @override
  initState() async {
    super.initState();
    conversation =
        await conversationApiProvider.fetchConversation(widget.conversationId);
  }

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
                child: Text(conversation.title,
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
                onPressed: () async {
                  // Call method to close connection
                  await conversationManager.exit();
                  await bus.publish({"state": "no_connection"});
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
