import "package:flutter/material.dart";

import "package:frontend_flutter/widgets/top_bar/index.dart";
import "package:frontend_flutter/widgets/conversation_list/index.dart";
import "package:frontend_flutter/widgets/contact_list/index.dart";
import "package:frontend_flutter/widgets/bottom_bar/index.dart";

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
            ConversationList(items: List<String>.generate(4, (i) => "Item $i")),
            ContactList(items: List<String>.generate(5, (i) => "Item $i")),
            ConversationList(items: List<String>.generate(6, (i) => "Item $i"))
          ]))
        ]),
        bottomSheet: BottomBar());
  }
}
