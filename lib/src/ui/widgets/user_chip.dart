import "package:flutter/material.dart";

import "../../models/user_model.dart";
import "./user_avatar.dart";

class UserChip extends StatelessWidget {
  final User user;

  UserChip({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Chip(
        avatar: UserAvatar(user: user, radius: 12.0),
        elevation: 1.5,
        label: Text(user.firstName + " " + user.lastName));
  }
}
