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
  int _tabIndex = 1;
  List<IconData> itemsList = [
    Icons.contacts,
    Icons.chat,
    Icons.settings,
  ];

  List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];

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

    // initialize conversation manager
    loginManager.getToken().then((authToken) async {
      await ConversationManager.init(authToken);
    });

    messageChannel.bus.listen(
        (Map<String, String> data) async => await _processMessage(data));

    connectionStatus.connectionChange.listen((bool online) {
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
    List<Widget> tabsList = [
      ContactTab(navigatorKey: navigatorKeys[0]),
      ConversationTab(navigatorKey: navigatorKeys[1]),
      SettingsTab(
          navigatorKey: navigatorKeys[2],
          toWelcomePage: () {
            Navigator.pushReplacementNamed(context, '/welcome');
          }),
    ];

    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_tabIndex].currentState.maybePop(),
      child: Scaffold(
        key: _scaffoldKey,
        body: IndexedStack(
          index: _tabIndex,
          children: tabsList,
        ),
        bottomNavigationBar:
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          BottomBar(conversationId: currentConversationId),
          BottomNavigationBar(
              onTap: (int index) {
                setState(() {
                  _tabIndex = index;
                });
              },
              items: itemsList.map((data) {
                return BottomNavigationBarItem(
                  icon: itemsList[_tabIndex] == data
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
      ),
    );
  }
}
