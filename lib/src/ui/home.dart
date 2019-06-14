import "package:flutter/material.dart";
import 'dart:ui' as ui;

import "./widgets/top_bar.dart";
import "./conversation_view/conversation_view.dart";
import "./contact_view/contact_view.dart";
import "./bottom_bar/bottom_bar.dart";
import "../services/heartbeat_manager.dart";
import "../services/conversation_manager.dart";
import "../blocs/message_bloc.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final heartbeatSendManager = HeartbeatSendManager();
  final conversationManager = ConversationManager();

  // Bottom Bar navigation
  int _tabNumber = 1;
  List<IconData> itemsList = [
    Icons.contacts,
    Icons.chat,
    Icons.settings,
  ];
  TabController controller;

  // Current conversaton
  String currentConversationId = "";

  @override
  initState() {
    super.initState();
    controller = TabController(vsync: this, length: 3);
    controller.index = 1; // Set default page to conversation page

    messageBloc.bus.listen(
        (Map<String, String> data) async => await _processMessage(data));
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  _processMessage(Map<String, String> data) async {
    if (data["state"] == "disconnect") {
      // Disconnect and change state
      await conversationManager.exit();
      setState(() {
        currentConversationId = "";
      });
    } else if (data["state"] == "connect") {
      // Connect and change state
      await conversationManager.join(data["conversationId"]);
      setState(() {
        currentConversationId = data["conversationId"];
      });
    } else {
      // show default
      await conversationManager.exit();
      setState(() {
        currentConversationId = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(children: <Widget>[
        TopBar(state: _tabNumber),
        Expanded(
            child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: controller,
                children: <Widget>[
              ContactView(),
              ConversationView(),
              Container(),
            ])),
      ]),
      bottomNavigationBar:
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        BottomBar(conversationId: currentConversationId),
        BottomNavigationBar(
            onTap: (int index) {
              setState(() {
                _tabNumber = index;
                controller.index = _tabNumber;
              });
            },
            items: itemsList.map((data) {
              return BottomNavigationBarItem(
                icon: itemsList[_tabNumber] == data
                    ? ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return ui.Gradient.linear(
                            Offset(4.0, 24.0),
                            Offset(24.0, 4.0),
                            [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColorDark,
                            ],
                          );
                        },
                        child: Icon(data, size: 30.0),
                      )
                    : Icon(data, color: Colors.grey),
                title: Container(),
              );
            }).toList())
      ]),
    );
  }
}
