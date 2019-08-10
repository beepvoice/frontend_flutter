import 'dart:async' show Future;

import "package:flutter/material.dart";
import 'package:frontend_flutter/src/ui/widgets/image_avatar.dart';

import "../../widgets/top_bar.dart";
import "../../widgets/list_button.dart";

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  final _textFieldController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    _textFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TopBar(title: "Settings", children: <Widget>[
        BackButton(),
        Spacer(),
      ]),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ImageAvatar(
                info: ImageAvatarInfo(lastName: 'Daniel'), radius: 70.0),
          ),
        ],
      ),
      Expanded(
        child: ListView(
          padding: EdgeInsets.only(top: 0.0),
          children: <Widget>[
            ListButton(
              icon: Icons.person,
              text: 'Daniel Lim Hai',
              subtitle: 'Name',
              onClickCallback: () {
                _displayTextFieldDialog(
                  context: context,
                  title: 'Edit Name',
                  existingText: 'Daniel Lim Hai',
                  hintText: 'Name',
                ).then((text) {
                  //TODO: Logic for changing name
                  print(text);
                });
              },
              textStyle: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: Theme.of(context).accentColor),
              iconColor: Theme.of(context).primaryColorDark,
            ),
            ListButton(
              icon: Icons.info,
              text: 'Hey there, I am using Beep!',
              subtitle: 'Bio',
              onClickCallback: () {
                _displayTextFieldDialog(
                  context: context,
                  title: 'Edit Bio',
                  existingText: 'Placeholder bio',
                  hintText: 'Bio',
                ).then((text) {
                  //TODO: Logic for changing bio
                  print(text);
                });
              },
              textStyle: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: Theme.of(context).accentColor),
              iconColor: Theme.of(context).primaryColorDark,
            ),
            Divider(),
            ListButton(
              icon: Icons.notifications,
              text: 'Notifications',
              onClickCallback: () {},
              textStyle: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: Theme.of(context).accentColor),
              iconColor: Theme.of(context).primaryColorDark,
            ),
            ListButton(
              icon: Icons.security,
              text: 'Security',
              onClickCallback: () {},
              textStyle: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: Theme.of(context).accentColor),
              iconColor: Theme.of(context).primaryColorDark,
            ),
            ListButton(
              icon: Icons.exit_to_app,
              text: 'Sign Out',
              onClickCallback: () {},
              textStyle: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: Colors.redAccent),
              iconColor: Colors.redAccent,
            ),
          ],
        ),
      ),
    ]);
  }

  _displayTextFieldDialog({
    @required BuildContext context,
    @required String title,
    String existingText,
    String hintText,
  }) async {
    _textFieldController.text = existingText;

    // Introduce artificial delay so the button press animation can be seen
    await new Future.delayed(const Duration(milliseconds: 220));

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: Theme.of(context).textTheme.title,
            ),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: hintText),
              autofocus: true,
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop(_textFieldController.text);
                },
              ),
            ],
          );
        });
  }
}
