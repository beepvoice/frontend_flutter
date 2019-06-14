import "package:flutter/material.dart";

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  SearchInput({@required this.controller, @required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Icon(Icons.search, color: Colors.grey[500])),
              Flexible(
                  child: TextField(
                      controller: controller,
                      autocorrect: false,
                      cursorWidth: 2.0,
                      cursorColor: Colors.grey[500],
                      style: Theme.of(context).textTheme.body2.copyWith(
                          color: Colors.grey[500], fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: false,
                          hintText: hintText,
                          hintStyle: Theme.of(context).textTheme.body2.copyWith(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w300,
                              )))),
            ])),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(10.00)),
        ));
  }
}
