import 'package:flutter/material.dart';

void main() => runApp(BeepApp());

class BeepApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new PreferredSize(
          child: new Container(
            padding: new EdgeInsets.only(top: 30.0),
            child: new Padding(
              padding:
                  const EdgeInsets.only(left: 30.0, top: 20.0, bottom: 20.0),
              child: new Text(
                'Arnold Parge',
                style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            decoration: new BoxDecoration(
                gradient:
                    new LinearGradient(colors: [Colors.red, Colors.yellow]),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey[500],
                    blurRadius: 20.0,
                    spreadRadius: 1.0,
                  )
                ]),
          ),
          preferredSize: new Size.fromHeight(150.0),
        ),
        body: new Center(
          child: new Text('Hello'),
        ),
      ),
    );
  }
}
