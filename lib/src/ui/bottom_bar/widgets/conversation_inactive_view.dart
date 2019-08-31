import "package:flutter/material.dart";

import "../../widgets/image_avatar.dart";
import "../../../models/conversation_model.dart";
import "../../../blocs/conversation_bloc.dart";

class ConversationInactiveView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConversationInactiveViewState();
  }
}

class _ConversationInactiveViewState extends State<ConversationInactiveView> {
  @override
  initState() {
    super.initState();
    conversationsBloc.fetchConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      StreamBuilder(
          stream: conversationsBloc.pinnedConversations,
          builder: (context, AsyncSnapshot<List<Conversation>> snapshot) {
            if (snapshot.hasData) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: (snapshot.data.length < 1)
                      ? <Widget>[
                          Spacer(),
                          Text("No pinned conversations :("),
                          Spacer()
                        ]
                      : snapshot.data
                          .map((conversation) => ImageAvatar(
                              radius: 18,
                              padding: EdgeInsets.only(right: 5.0),
                              info: ImageAvatarInfo.fromConversation(
                                  conversation)))
                          .toList());
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          })
    ]));
  }
}
