import "package:flutter/material.dart";

import "../../services/peer_manager.dart";
import "../../blocs/bottom_bar_bus.dart";
import "../../../settings.dart";

class BottomBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomBarState();
  }
}

class _BottomBarState extends State<BottomBar> {
  final double barHeight = 80.0;
  PeerManager _peerManager;

  @override
  void initState() {
    super.initState();
    // _peerManager = PeerManager(globalUserId, "1");
    print("hi");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.canvas,
        elevation: 10.0,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
        child: Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 20.0),
                      width: 22.0,
                      height: 22.0,
                      decoration: BoxDecoration(
                          color: Theme.of(context).indicatorColor,
                          shape: BoxShape.circle)),
                  Text("Family Chat",
                      style: Theme.of(context)
                          .textTheme
                          .display1
                          .copyWith(color: Theme.of(context).accentColor)),
                  Spacer(),
                  IconButton(
                      color: Theme.of(context).accentColor,
                      icon: Icon(Icons.info),
                      onPressed: () {
                        print("Pressed");
                      }),
                  IconButton(
                      color: Theme.of(context).accentColor,
                      icon: Icon(Icons.close),
                      onPressed: () {
                        print("Pressed close");
                        bottomBarBus
                            .publish(<String, dynamic>{"event": "close"});
                      }),
                ])));
  }
}
