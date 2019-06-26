import "package:flutter/material.dart";

import "../../../models/user_model.dart";

import "../../widgets/contact_item.dart";
import "../../widgets/top_bar.dart";
import "../../widgets/small_text_button.dart";

class NewGroupInfoView extends StatefulWidget {
  final List<User> users;

  NewGroupInfoView({@required this.users});

  @override
  State<StatefulWidget> createState() {
    return _NewGroupInfoViewState();
  }
}

class _NewGroupInfoViewState extends State<NewGroupInfoView> {
  final descriptionController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TopBar(title: "New Group", children: <Widget>[
        IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        Spacer(),
        SmallTextButton(text: "Create", onClickCallback: () {})
      ]),
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Container(
            height: 70.0,
            width: 70.0,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(35.0)))),
        Flexible(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          TextField(
              controller: nameController,
              autocorrect: false,
              cursorWidth: 2.0,
              cursorColor: Colors.grey[500],
              style: Theme.of(context).textTheme.subtitle.copyWith(
                  color: Colors.grey[500], fontWeight: FontWeight.w300),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: false,
                  hintText: "Enter group name",
                  hintStyle: Theme.of(context)
                      .textTheme
                      .subtitle
                      .copyWith(color: Colors.grey[500]))),
          TextField(
              controller: descriptionController,
              autocorrect: false,
              cursorWidth: 2.0,
              cursorColor: Colors.grey[500],
              style: Theme.of(context).textTheme.subtitle.copyWith(
                  color: Colors.grey[500], fontWeight: FontWeight.w300),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: false,
                  hintText: "Enter group description",
                  hintStyle: Theme.of(context)
                      .textTheme
                      .subtitle
                      .copyWith(color: Colors.grey[500]))),
        ])),
      ]),
      Expanded(
          child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.users
                      .map((user) => ContactItem(user: user))
                      .toList())))
    ]);
  }
}
