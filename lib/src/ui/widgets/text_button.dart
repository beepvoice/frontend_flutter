import "package:flutter/material.dart";

typedef void OnClickCallback();

class TextButton extends StatelessWidget {
  final String text;
  final OnClickCallback onClickCallback;

  TextButton({@required this.text, @required this.onClickCallback});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text(text.toUpperCase(),
            style: Theme.of(context).textTheme.display1.copyWith(
                fontSize: 15.0, color: Theme.of(context).primaryColorDark)),
        color: Colors.white,
        highlightColor: Colors.white,
        splashColor: Colors.white,
        padding:
            EdgeInsets.only(top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: onClickCallback);
  }
}
