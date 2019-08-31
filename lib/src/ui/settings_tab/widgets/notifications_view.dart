import "package:flutter/material.dart";
import 'package:frontend_flutter/src/ui/widgets/list_text_button.dart';

import "../../widgets/top_bar.dart";

class NotificationsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationsViewState();
  }
}

class _NotificationsViewState extends State<NotificationsView> {
  bool _inChatSounds = false;

  @override
  Widget build(BuildContext context) {
    var _buttonTextTheme = Theme.of(context)
        .textTheme
        .title
        .copyWith(color: Theme.of(context).accentColor);
    return Column(
      children: <Widget>[
        TopBar(
          title: "Notifications",
          children: <Widget>[
            BackButton(),
            Spacer(),
          ],
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(top: 0.0),
            children: <Widget>[
              SwitchListTile(
                title: Text('In-Chat Sounds', style: _buttonTextTheme),
                value: _inChatSounds,
                onChanged: (bool value) {
                  setState(() {
                    _inChatSounds = value;
                  });
                },
              ),
              ListTextButton(
                text: 'Notification Sound',
                subtitle: 'Default',
                textStyle: _buttonTextTheme,
                onClickCallback: () {
                  
                },
              ),
              ListTextButton(
                text: 'Vibrate',
                subtitle: 'Default',
                textStyle: _buttonTextTheme,
                onClickCallback: () {
                  
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
