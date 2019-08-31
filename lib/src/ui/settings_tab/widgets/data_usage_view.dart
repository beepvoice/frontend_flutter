import "package:flutter/material.dart";

import "../../widgets/top_bar.dart";
import "../../widgets/list_button.dart";

class DataUsageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DataUsageViewState();
  }
}

class _DataUsageViewState extends State<DataUsageView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TopBar(
          title: "Data Usage",
          children: <Widget>[
            BackButton(),
            Spacer(),
          ],
        ),
        Text('Data Usage View'),
      ],
    );
  }
}
