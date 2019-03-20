import "package:flutter/material.dart";

import "../../widgets/user_avatar.dart";
import "../../../models/user_model.dart";

class ConversationInactiveView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          UserAvatar(user: User("1", "Isaac", "Tay", "+65 91043593")),
          UserAvatar(user: User("1", "Isaac", "Tay", "+65 91043593")),
          UserAvatar(user: User("1", "Isaac", "Tay", "+65 91043593"))
        ]));
  }
}
