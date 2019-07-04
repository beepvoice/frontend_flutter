import "package:flutter/material.dart";

import "../../models/user_model.dart";
import "../widgets/user_avatar.dart";

typedef void OnClickCallback(bool state);

class ContactItem extends StatefulWidget {
  final User user;
  final bool selectable;
  final OnClickCallback onClickCallback;

  ContactItem(
      {@required this.user, this.onClickCallback, this.selectable: false});

  @override
  State<StatefulWidget> createState() {
    return _ContactItemState();
  }
}

class _ContactItemState extends State<ContactItem> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        elevation: 1,
        child: InkWell(
            onTap: () async {
              if (widget.selectable == true) {
                setState(() {
                  selected = !selected;
                });
              }

              widget.onClickCallback(selected);
            },
            child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      (widget.selectable)
                          ? Checkbox(
                              value: selected,
                              activeColor: Theme.of(context).primaryColorDark,
                              onChanged: (state) {
                                setState(() {
                                  selected = !selected;
                                });

                                widget.onClickCallback(selected);
                              })
                          : Container(),
                      UserAvatar(
                          user: widget.user,
                          radius: 18.0,
                          padding: EdgeInsets.only(
                              left: ((widget.selectable) ? 0 : 15.0))),
                      Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    widget.user.firstName +
                                        " " +
                                        widget.user.lastName,
                                    style: Theme.of(context).textTheme.title,
                                    overflow: TextOverflow.ellipsis),
                                Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Text("Last seen x ago",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle
                                            .copyWith(
                                                color: Color(0xFF455A64)))),
                              ]))
                    ]))));
  }
}
