import "package:flutter/material.dart";

import "../../widgets/top_bar.dart";
import "../../widgets/list_button.dart";

class NotificationsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationsViewState();
  }
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TopBar(
          title: "Notifications",
          children: <Widget>[
            BackButton(),
            Spacer(),
          ],
        ),
        Text('Notifications View'),
      ],
    );
  }
}
