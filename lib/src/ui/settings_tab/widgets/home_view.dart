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
  final searchController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
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
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     Text(
        //       'Daniel Lim Hai',
        //       style: Theme.of(context)
        //           .textTheme
        //           .title
        //           .copyWith(fontSize: 18.0),
        //     ),
        //     Text(
        //       'Insert bio here',
        //       style: Theme.of(context).textTheme.subtitle,
        //     ),
        //   ],
        // ),
      ),
      Expanded(
        child: ListView(
          padding: EdgeInsets.only(top: 0.0),
          children: <Widget>[
            ListButton(
              icon: Icons.person,
              text: 'Daniel Lim Hai',
              subtitle: 'Name',
              onClickCallback: () {},
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
              onClickCallback: () {},
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
}
