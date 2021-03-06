import "package:flutter/material.dart";

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;

  PhoneInput({@required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Container(
              height: 45,
              width: 45,
              child: Center(
                  child: Text("+65",
                      style: Theme.of(context).textTheme.title.copyWith(
                          color: Theme.of(context).primaryColorDark))),
              decoration: BoxDecoration(
                color: Colors.white,
                /*borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  bottomLeft: Radius.circular(5.0))*/
              )),
          Expanded(
              child: TextField(
                  controller: controller,
                  autocorrect: false,
                  cursorWidth: 2.0,
                  cursorColor: Colors.white,
                  style: Theme.of(context).accentTextTheme.title,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0x10000000),
                    hintText: "Phone number",
                    hintStyle: Theme.of(context).accentTextTheme.title,
                  ))),
        ]));
  }
}
