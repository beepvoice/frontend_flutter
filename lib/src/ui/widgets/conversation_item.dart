import "package:flutter/material.dart";
import 'package:flutter_slidable/flutter_slidable.dart';

import "../../models/user_model.dart";
import "../../models/conversation_model.dart";
import "../../blocs/conversation_bloc.dart";
import "../../blocs/message_bloc.dart";

import "../widgets/user_avatar.dart";

class ConversationItem extends StatefulWidget {
  final Conversation conversation;
  final bool pinnable;
  final bool deletable;

  ConversationItem({@required this.conversation, this.pinnable=true, this.deletable=true});
  @override
  State<StatefulWidget> createState() {
    return _ConversationItemState(conversation: conversation);
  }
}

class _ConversationItemState extends State<ConversationItem> {
  final bloc;
  final Conversation conversation;

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
    Widget item = Material(
        type: MaterialType.transparency,
        elevation: 1,
        child: InkWell(
            onTap: () async {
              await messageChannel.publish({
                "target": "home",
                "state": "connect",
                "conversationId": conversation.id
              });
            },
            child: Container(
                padding: EdgeInsets.only(
                    top: 8.0, left: 10.0, right: 10.0, bottom: 8.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      StreamBuilder(
                          stream: bloc.members,
                          builder:
                              (context, AsyncSnapshot<List<User>> snapshot) {
                            if (snapshot.hasData) {
                              return avatarBuilder(snapshot.data);
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            return SizedBox(width: 18.0, height: 18.0);
                          }),
                      Expanded(
                          child: Container(
                              padding: EdgeInsets.only(left: 10.0, right: 5.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(conversation.title,
                                        style:
                                            Theme.of(context).textTheme.title),
                                    Text("yaddaydaadadyasdhbsjdfhsbjdfhsbdug",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle
                                            .copyWith(
                                                color: Color(0xFF455A64))),
                                  ]))),
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Text("12:25 PM",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .display2
                                .copyWith(
                                    color: Theme.of(context).primaryColorDark)),
                      ])
                    ]))));
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      showAllActionsThreshold: 1,
      movementDuration: Duration(milliseconds: 500),
      child: item,
      actions: (widget.pinnable) ?
        <Widget>[
         IconSlideAction(
          color: Colors.green,
          icon: Icons.star,
          onTap: () => print('Pin'))]
        : [],
      secondaryActions: (widget.deletable) ?
        <Widget>[
          IconSlideAction(
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => print('Delete'))]
        : [],
    );
  }

  Widget avatarBuilder(List<User> data) {
    if (data.length == 1) {
      return UserAvatar(radius: 25.0, user: data[0]);
    } else if (data.length > 1) {
      final groupUser = new User("0", conversation.title, "", "", "", "", "");
      return UserAvatar(radius: 25.0, user: groupUser);
    } else {
      return Container();
    }
  }
}
