import "package:flutter/material.dart";
import 'package:frontend_flutter/src/services/connection_status.dart';
import 'dart:ui' as ui;
import 'dart:async';

import "../services/heartbeat_manager.dart";
import "../services/conversation_manager.dart";
import "../services/login_manager.dart";

import "../blocs/message_bloc.dart";

import "./conversation_tab/conversation_tab.dart";
import "./contact_tab/contact_tab.dart";
import './settings_tab/settings_tab.dart';
import "./bottom_bar/bottom_bar.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final heartbeatSendManager = HeartbeatSendManager();
  final conversationManager = ConversationManager();
  final loginManager = LoginManager();

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

  // Online status
  ConnectionStatus connectionStatus = ConnectionStatus();
  bool _isOnline = true;
  bool _connectionStatusVisible = false;
  Timer _connectionStatusVisibilityTimer;

  @override
  initState() {
    super.initState();
    controller = TabController(vsync: this, length: 3);
    controller.index = 1; // Set default page to conversation page

    // initialize conversation manager
    loginManager.getToken().then((authToken) async {
      await ConversationManager.init(authToken);
    });

    messageChannel.bus.listen(
        (Map<String, String> data) async => await _processMessage(data));

    connectionStatus.connectionChange.listen((bool online) {
      // TODO: implement some timer to remove the message after 3 seconds
      setState(() {
        _isOnline = online;
        _connectionStatusVisible = true;
      });

      if (_connectionStatusVisibilityTimer != null) {
        _connectionStatusVisibilityTimer.cancel();
        _connectionStatusVisibilityTimer = null;
      }

      _connectionStatusVisibilityTimer = Timer(Duration(seconds: 3), () {
        setState(() {
          _connectionStatusVisible = false;
        });
      });
    });
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  _processMessage(Map<String, String> data) async {
    if (data["target"] == "home") {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: <Widget>[
            ContactTab(),
            ConversationTab(),
            SettingsTab(toWelcomePage: () {
              Navigator.pushNamed(context, '/welcome');
            }),
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
                        child: Icon(data, size: 25.0),
                      )
                    : Icon(data, color: Colors.grey, size: 20),
                title: Container(),
              );
            }).toList()),
        Visibility(
          visible: _connectionStatusVisible,
          child: Container(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment(0.0, 0.0),
              color: _isOnline ? Colors.green : Colors.red,
              child: Text(_isOnline ? 'Online' : 'Offline')),
        ),
      ]),
    );
  }
}
