import "package:flutter/material.dart";

import "../../models/user_model.dart";
import "../../models/conversation_model.dart";
import "../../blocs/conversation_bloc.dart";

import "user_avatar.dart";

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

  _ConversationItemState({@required this.conversation})
      : bloc = ConversationMembersBloc(conversation.id);

  @override
  void initState() {
    super.initState();
    bloc.fetchConversationMembers();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      onTap: () => {},
      contentPadding:
          EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
      title: Text(conversation.title, style: Theme.of(context).textTheme.title),
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
            StreamBuilder(
                stream: bloc.members,
                builder: (context, AsyncSnapshot<List<User>> snapshot) {
                  if (snapshot.hasData) {
                    return membersBuilder(snapshot.data);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          ]),
    );
  }

  Widget membersBuilder(List<User> data) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data
            .map((user) => UserAvatar(
                padding: EdgeInsets.only(top: 10.0, left: 1.0), user: user))
            .toList());
  }
}
