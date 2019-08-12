import "package:flutter/material.dart";

import "../../widgets/top_bar.dart";
import "../../widgets/list_button.dart";

class InterfaceView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InterfaceViewState();
  }
}

class _InterfaceViewState extends State<InterfaceView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TopBar(
          title: "Interface",
          children: <Widget>[
            BackButton(),
            Spacer(),
          ],
        ),
        Text('Interface View'),
      ],
    );
  }
}
