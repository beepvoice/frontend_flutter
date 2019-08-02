import "package:flutter/material.dart";

import "../../widgets/image_avatar.dart";
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
            ImageAvatar(
                radius: 18,
                padding: EdgeInsets.only(right: 5.0),
                info: ImageAvatarInfo.fromUser(
                    User("1", "Isaac", "Tay", "+65 91043593", "", "", ""))),
            ImageAvatar(
                radius: 18,
                padding: EdgeInsets.only(right: 5.0),
                info: ImageAvatarInfo.fromUser(
                    User("1", "Isaac", "Tay", "+65 91043593", "", "", ""))),
            ImageAvatar(
                radius: 18,
                padding: EdgeInsets.only(right: 5.0),
                info: ImageAvatarInfo.fromUser(
                    User("1", "Isaac", "Tay", "+65 91043593", "", "", "")))
          ])
    ]));
  }
}
