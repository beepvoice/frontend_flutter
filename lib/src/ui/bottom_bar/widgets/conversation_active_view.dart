import "package:flutter/material.dart";

import "../../widgets/user_avatar.dart";
import "../../../resources/conversation_api_provider.dart";
import "../../../models/user_model.dart";
import "../../../models/conversation_model.dart";
import "../../../blocs/message_bloc.dart";

class ConversationActiveView extends StatefulWidget {
  final String conversationId;

  ConversationActiveView({@required this.conversationId});

  @override
  State<StatefulWidget> createState() {
    return _ConversationActiveViewState();
  }
}

class _ConversationActiveViewState extends State<ConversationActiveView> {
  final bus = messageBloc;
  final conversationApiProvider = ConversationApiProvider();
  Conversation _conversation;
  List<Widget> _users;

  @override
  initState() {
    super.initState();
    _getConversation();
    _getConversationMembers();
  }

  _getConversation() {
    conversationApiProvider
        .fetchConversation(widget.conversationId)
        .then((conversation) {
      setState(() {
        _conversation = conversation;
      });
    });
  }

  _getConversationMembers() {
    conversationApiProvider
        .fetchConversationMembers(widget.conversationId)
        .then((users) {
      print(users[0].id);
      setState(() {
        _users = users
            .map((user) => UserAvatar(
                radius: 18.0, padding: EdgeInsets.only(right: 5.0), user: user))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if ((_conversation == null) || (_users == null)) {
      return SizedBox(height: 20, width: 20);
    }

    return Container(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 15.0,
                height: 15.0,
                decoration: BoxDecoration(
                    color: Theme.of(context).indicatorColor,
                    shape: BoxShape.circle)),
            Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Text(_conversation.title,
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
                  await bus.publish({"state": "disconnect"});
                  print("Pressed close");
                }),
          ]),
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _users),
    ]));
  }
}
