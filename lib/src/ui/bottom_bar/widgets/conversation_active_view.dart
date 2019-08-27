import "package:flutter/material.dart";

import "../../widgets/image_avatar.dart";
import "../../../models/conversation_model.dart";
import "../../../models/user_model.dart";
import "../../../blocs/conversation_bloc.dart";
import "../../../blocs/message_bloc.dart";

class ConversationActiveView extends StatefulWidget {
  final String conversationId;

  ConversationActiveView({@required this.conversationId});

  @override
  State<StatefulWidget> createState() {
    return _ConversationActiveViewState(conversationId: conversationId);
  }
}

class _ConversationActiveViewState extends State<ConversationActiveView> {
  final bloc;
  final String conversationId;
  Widget _avatar;

  _ConversationActiveViewState({@required this.conversationId})
      : bloc = ConversationMembersBloc(conversationId);

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: conversationBloc.getConversation(widget.conversationId),
        builder:
            (BuildContext context, AsyncSnapshot<Conversation> conversation) {
          if (conversation.hasData) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder(
                      stream: bloc.members,
                      builder: (context, AsyncSnapshot<List<User>> members) {
                        if (members.hasData) {
                          _avatar =
                              avatarBuilder(members.data, conversation.data);
                        } else if (members.hasError) {
                          return Text(members.error.toString());
                        }

                        return _avatar ?? SizedBox(width: 18.0, height: 18.0);
                      }),
                  Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: Text(conversation.data.title,
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
                        await messageChannel
                            .publish({"target": "home", "state": "disconnect"});
                        print("Pressed close");
                      }),
                ]);
          } else if (conversation.hasError) {
            return Text(conversation.error.toString());
          }
        });
  }

  Widget avatarBuilder(List<User> data, Conversation conversation) {
    if (data.length == 1) {
      // This means that it is a DM
      final avatarInfo = ImageAvatarInfo.fromUser(data[0]);
      return ImageAvatar(info: avatarInfo, radius: 25.0);
    } else if (data.length > 1) {
      // This means that it is a group conversation
      final avatarInfo = ImageAvatarInfo.fromConversation(conversation);
      return ImageAvatar(info: avatarInfo, radius: 25.0);
    } else {
      return Container();
    }
  }
}
