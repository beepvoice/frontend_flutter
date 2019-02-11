import "package:flutter/material.dart";
import "package:frontend_flutter/widgets/user_avatar/index.dart";

class ContactItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: UserAvatar(active: true, name: "SU", radius: 25.0),
        title: Text("Sudharshan"));
  }
}
