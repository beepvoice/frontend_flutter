import 'dart:async' show Future;

import "package:flutter/material.dart";
import 'package:frontend_flutter/src/ui/widgets/image_avatar.dart';

import "../../../services/login_manager.dart";
import "../../../models/user_model.dart";
import "../../../resources/user_api_provider.dart";
import "../../widgets/top_bar.dart";
import "../../widgets/list_button.dart";

class HomeView extends StatefulWidget {
  final VoidCallback toWelcomePage;

  HomeView({@required this.toWelcomePage});

  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  final _textFieldController = TextEditingController();
  final loginManager = LoginManager();
  User currentUser;

  @override
  initState() {
    super.initState();

    // Getting current user name and bio
    loginManager.getUser().then((User user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    _textFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _titleTheme = Theme.of(context)
        .textTheme
        .title
        .copyWith(color: Theme.of(context).accentColor);
    return Column(
      children: <Widget>[
        TopBar(
          title: "Settings",
          children: <Widget>[
            Visibility(
              child: BackButton(),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: false,
            ),
            Spacer(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned(
                  child: ImageAvatar(
                      padding: EdgeInsets.all(20.0),
                      info: ImageAvatarInfo.fromUser(currentUser),
                      radius: 70.0,
                      showStatus: false),
                ),
                Positioned(
                  top: 115.0,
                  left: 115.0,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColorDark,
                    onPressed: () => {},
                    mini: true,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(top: 0.0),
            children: <Widget>[
              ListButton(
                icon: Icons.person,
                text: currentUser.firstName ?? "",
                subtitle: 'First name',
                onClickCallback: () {
                  _displayTextFieldDialog(
                    context: context,
                    title: 'Edit first name',
                    existingText:
                        currentUser.firstName + " " + currentUser.lastName,
                    hintText: 'First name',
                  ).then((text) {
                    if (text != null) {
                      setState(() {
                        userApiProvider.updateUser(firstName: text);
                        print(text);
                      });
                    }
                  });
                },
                textStyle: _titleTheme,
                iconColor: Theme.of(context).primaryColorDark,
              ),
              ListButton(
                icon: Icons.person,
                text: currentUser.lastName ?? "",
                subtitle: 'Last name',
                onClickCallback: () {
                  _displayTextFieldDialog(
                    context: context,
                    title: 'Edit last name',
                    existingText:
                        currentUser.firstName + " " + currentUser.lastName,
                    hintText: 'Last name',
                  ).then((text) {
                    if (text != null) {
                      setState(() {
                        userApiProvider.updateUser(lastName: text);
                        print(text);
                      });
                    }
                  });
                },
                textStyle: _titleTheme,
                iconColor: Theme.of(context).primaryColorDark,
              ),
              ListButton(
                icon: Icons.person,
                text: currentUser.username ?? "",
                subtitle: 'Username',
                onClickCallback: () {
                  _displayTextFieldDialog(
                    context: context,
                    title: 'Edit username',
                    existingText:
                        currentUser.firstName + " " + currentUser.lastName,
                    hintText: 'Username',
                  ).then((text) {
                    if (text != null) {
                      setState(() {
                        userApiProvider.updateUser(username: text);
                        print(text);
                      });
                    }
                  });
                },
                textStyle: _titleTheme,
                iconColor: Theme.of(context).primaryColorDark,
              ),
              ListButton(
                icon: Icons.info,
                text: currentUser.bio,
                subtitle: 'Bio',
                onClickCallback: () {
                  _displayTextFieldDialog(
                    context: context,
                    title: 'Edit Bio',
                    existingText: currentUser.bio,
                    hintText: 'Bio',
                  ).then((text) {
                    if (text != null) {
                      setState(() {
                        userApiProvider.updateUser(bio: text);
                        print(text);
                      });
                    }
                  });
                },
                textStyle: _titleTheme,
                iconColor: Theme.of(context).primaryColorDark,
              ),
              Divider(),
              ListButton(
                icon: Icons.color_lens,
                text: 'Interface',
                onClickCallback: () {
                  Navigator.of(context).pushNamed("settings/interface");
                },
                textStyle: _titleTheme,
                iconColor: Theme.of(context).primaryColorDark,
              ),
              ListButton(
                icon: Icons.notifications,
                text: 'Notifications',
                onClickCallback: () {
                  Navigator.of(context).pushNamed("settings/notifications");
                },
                textStyle: _titleTheme,
                iconColor: Theme.of(context).primaryColorDark,
              ),
              ListButton(
                icon: Icons.security,
                text: 'Privacy and Security',
                onClickCallback: () {
                  Navigator.of(context).pushNamed("settings/privacy_security");
                },
                textStyle: _titleTheme,
                iconColor: Theme.of(context).primaryColorDark,
              ),
              ListButton(
                icon: Icons.data_usage,
                text: 'Data Usage',
                onClickCallback: () {
                  Navigator.of(context).pushNamed("settings/data_usage");
                },
                textStyle: _titleTheme,
                iconColor: Theme.of(context).primaryColorDark,
              ),
              Divider(),
              ListButton(
                icon: Icons.exit_to_app,
                text: 'Sign Out',
                onClickCallback: () async {
                  await loginManager.logout();
                  widget.toWelcomePage();
                },
                textStyle: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.redAccent),
                iconColor: Colors.redAccent,
              ),
            ],
          ),
        ),
      ],
    );
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
      },
    );
  }
}
