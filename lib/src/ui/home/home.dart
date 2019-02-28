import "package:flutter/material.dart";

import "./widgets/top_bar.dart";
import "./widgets/conversation_list.dart";
import "./widgets/contact_list.dart";
import "./widgets/bottom_bar.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> titleList = ["Conversations", "Contacts", "Settings"];
  final PageController controller = PageController();

  int _pageNumber = 0;

  @override
  initState() {
    super.initState();
    controller.addListener(_updatePageNumber);
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  _updatePageNumber() {
    setState(() {
      _pageNumber = controller.page.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
          TopBar(title: titleList[_pageNumber], pageNumber: _pageNumber),
          Expanded(
              child: PageView(controller: controller, children: <Widget>[
            ConversationList(),
            ContactList(),
          ]))
        ]),
        bottomSheet: BottomBar());
  }
}
