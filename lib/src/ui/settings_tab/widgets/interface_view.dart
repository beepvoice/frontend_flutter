import "package:flutter/material.dart";
import 'package:frontend_flutter/src/ui/widgets/list_text_button.dart';

import "../../widgets/top_bar.dart";
import "../../widgets/list_button.dart";

class InterfaceView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InterfaceViewState();
  }
}

class _InterfaceViewState extends State<InterfaceView> {
  bool _enterToSend = false;

  @override
  Widget build(BuildContext context) {
    var _buttonTextTheme = Theme.of(context)
        .textTheme
        .title
        .copyWith(color: Theme.of(context).accentColor);

    return Column(
      children: <Widget>[
        TopBar(
          title: "Interface",
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
                title: Text('Enter to Send', style: _buttonTextTheme),
                value: _enterToSend,
                onChanged: (bool value) {
                  setState(() {
                    _enterToSend = value;
                  });
                },
              ),
              ListTextButton(
                text: 'Font Size',
                subtitle: 'Medium',
                textStyle: _buttonTextTheme,
                onClickCallback: () {
                  
                },
              ),
              ListTextButton(
                text: 'Wallpaper',
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
