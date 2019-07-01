import "package:flutter/material.dart";

typedef void OnClickCallback();

class SmallTextButton extends StatelessWidget {
  final String text;
  final OnClickCallback onClickCallback;

  SmallTextButton({@required this.text, @required this.onClickCallback});
  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        elevation: 1,
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: GestureDetector(
                onTap: onClickCallback,
                child: Text(text,
                    style: Theme.of(context)
                        .accentTextTheme
                        .title
                        .copyWith(fontWeight: FontWeight.w300)))));
  }
}
