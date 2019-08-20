import "package:flutter/material.dart";

typedef void OnClickCallback();

class ListTextButton extends StatelessWidget {
  final String text;
  final OnClickCallback onClickCallback;
  final String subtitle;
  final TextStyle textStyle;
  final TextStyle subtitleStyle;

  ListTextButton({
    @required this.text,
    @required this.onClickCallback,
    this.subtitle,
    this.textStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      elevation: 1,
      child: InkWell(
        onTap: onClickCallback,
        child: Container(
          height: 62.0,
          padding:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: textStyle ??
                    Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Theme.of(context).primaryColorDark),
              ),
              (subtitle == null)
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(top: 3.0),
                      child: Text(
                        subtitle,
                        style: subtitleStyle ??
                            Theme.of(context).textTheme.subtitle,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
