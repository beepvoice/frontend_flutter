import "package:flutter/material.dart";

import "../../widgets/top_bar.dart";
import "../../widgets/list_button.dart";

class PrivacySecurityView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PrivacySecurityViewState();
  }
}

class _PrivacySecurityViewState extends State<PrivacySecurityView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TopBar(
          title: "Privacy and Security",
          children: <Widget>[
            BackButton(),
            Spacer(),
          ],
        ),
        Text('Privacy and Security View'),
      ],
    );
  }
}
