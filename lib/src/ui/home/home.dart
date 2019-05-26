import "package:flutter/material.dart";

import "./widgets/top_bar.dart";
import "./widgets/conversation_list.dart";
import "./widgets/contact_list.dart";
import "../bottom_bar/bottom_bar.dart";
import "../../services/heartbeat_manager.dart";
import "../../services/conversation_manager.dart";
import "../../blocs/message_bloc.dart";
import "../../blocs/heartbeat_bloc.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> titleList = ["Conversations", "Contacts", "Settings"];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final PageController controller = PageController();
  final heartbeatSendManager = HeartbeatSendManager();
  final conversationManager = ConversationManager();

  int _pageNumber = 0;

  PersistentBottomSheetController bottomBarController;

  @override
  initState() {
    super.initState();
    controller.addListener(_updatePageNumber);

    messageBloc.bus.listen(
        (Map<String, String> data) async => await _processMessage(data));
    _setupBottomState();
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

  _processMessage(Map<String, String> data) async {
    if (data["state"] == "disconnect") {
      // Disconnect and change state
      await conversationManager.exit();
      bottomBarController.close();
      bottomBarController = _scaffoldKey.currentState.showBottomSheet<void>(
          (BuildContext context) => BottomBar(conversationId: ""));
    } else if (data["state"] == "connect") {
      // Connect and change state
      await conversationManager.join(data["conversationId"]);
      bottomBarController.close();
      bottomBarController = _scaffoldKey.currentState.showBottomSheet<void>(
          (BuildContext context) =>
              BottomBar(conversationId: data["conversationId"]));
    } else {
      // show default
      await conversationManager.exit();
      bottomBarController.close();
      bottomBarController = _scaffoldKey.currentState.showBottomSheet<void>(
          (BuildContext context) => BottomBar(conversationId: ""));
    }
  }

  _setupBottomState() {
    conversationManager.get().then((conversationId) {
      bottomBarController = _scaffoldKey.currentState.showBottomSheet<void>(
          (BuildContext context) => BottomBar(conversationId: conversationId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(children: <Widget>[
        TopBar(title: titleList[_pageNumber], pageNumber: _pageNumber),
        Expanded(
            child: PageView(controller: controller, children: <Widget>[
          ConversationList(),
          ContactList(),
        ])),
      ]),
    );
  }
}
