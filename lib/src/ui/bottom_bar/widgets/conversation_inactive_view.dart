import "package:flutter/material.dart";

import "../../widgets/user_avatar.dart";
import "../../../models/user_model.dart";

class ConversationInactiveView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                user: User("1", "Isaac", "Tay", "+65 91043593"))
          ])
    ]));
  }
}
