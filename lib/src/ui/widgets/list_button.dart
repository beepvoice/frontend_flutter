import "package:flutter/material.dart";

typedef void OnClickCallback();

class ListButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final OnClickCallback onClickCallback;

  ListButton(
      {@required this.icon,
      @required this.text,
      @required this.onClickCallback});

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        elevation: 1,
        child: InkWell(
            onTap: onClickCallback,
            child: Container(
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 12.0, bottom: 12.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(icon,
                          size: 30.0,
                          color: Theme.of(context).primaryColorDark),
                      Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(text,
                              style: Theme.of(context).textTheme.title.copyWith(
                                  color: Theme.of(context).primaryColorDark))),
                    ]))));
  }
}
