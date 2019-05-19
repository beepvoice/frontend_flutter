import "package:flutter/material.dart";

import "../../../models/user_model.dart";
import "../../../models/conversation_model.dart";
import "../../../blocs/conversation_bloc.dart";
import "../../../blocs/message_bloc.dart";

import "../../widgets/user_avatar.dart";

class ConversationItem extends StatefulWidget {
  final Conversation conversation;

  ConversationItem({@required this.conversation});
  @override
  State<StatefulWidget> createState() {
    return _ConversationItemState(conversation: conversation);
  }
}

class _ConversationItemState extends State<ConversationItem> {
  final bloc;
  final Conversation conversation;
  final bus = messageBloc;

  _ConversationItemState({@required this.conversation})
      : bloc = ConversationMembersBloc(conversation.id);

  @override
  void initState() {
    super.initState();
    bloc.fetchMembers();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        elevation: 0,
        child: InkWell(
            onTap: () async {
              await bus.publish(
                  {"state": "connect", "conversationId": conversation.id});
            },
            child: Container(
                padding: EdgeInsets.only(
                    top: 5.0, left: 20.0, right: 20.0, bottom: 5.0),
                child: Column(children: <Widget>[
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(conversation.title,
                            style: Theme.of(context).textTheme.title),
                        Spacer(),
                        Text("1m ago",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .body1
                                .copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColorDark)),
                      ]),
                  Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Text(
                                    "I might have forgotten to close the windows",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.subtitle)),
                            StreamBuilder(
                                stream: bloc.members,
                                builder: (context,
                                    AsyncSnapshot<List<User>> snapshot) {
                                  if (snapshot.hasData) {
                                    return membersBuilder(snapshot.data);
                                  } else if (snapshot.hasError) {
                                    return Text(snapshot.error.toString());
                                  }
                                  return SizedBox(width: 18.0, height: 18.0);
                                }),
                          ]))
                ]))));
  }

  Widget membersBuilder(List<User> data) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data
            .map((user) => UserAvatar(
                radius: 18.0,
                padding: EdgeInsets.only(top: 0.0, left: 5.0),
                user: user))
            .toList());
  }
}
