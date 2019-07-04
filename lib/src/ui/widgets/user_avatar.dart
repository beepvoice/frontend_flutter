import "package:flutter/material.dart";
import "dart:io";

import "../../models/user_model.dart";
import "../../blocs/heartbeat_bloc.dart";

class UserAvatar extends StatefulWidget {
  final User user;
  final EdgeInsetsGeometry padding;
  final double radius;

  UserAvatar(
      {@required this.user,
      this.padding: const EdgeInsets.all(0.0),
      this.radius: 20.0});

  @override
  State<StatefulWidget> createState() {
    return _UserAvatarState();
  }
}

class _UserAvatarState extends State<UserAvatar> {
  String lastStatus = "";
  String firstLetter;
  String lastLetter;

  List<Color> profileColors;
  File profilePic;

  @override
  initState() {
    super.initState();

    lastStatus = heartbeatReceiverBloc.getLastStatus(widget.user.id);

    if (widget.user.profilePic == "") {
      firstLetter =
          (widget.user.firstName.isEmpty) ? '' : widget.user.firstName[0];
      lastLetter =
          (widget.user.lastName.isEmpty) ? '' : widget.user.lastName[0];
      profileColors = _stringToColor(widget.user.lastName);
    } else {
      // Get picture
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding,
        child: Stack(alignment: Alignment.bottomRight, children: <Widget>[
          Container(
              height: (widget.radius * 2),
              width: (widget.radius * 2),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [
                        0,
                        1
                      ],
                      colors: [
                        profileColors[0],
                        profileColors[1],
                      ]),
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.radius))),
              child: Center(
                child: Text(
                  firstLetter.toUpperCase() + lastLetter.toUpperCase(),
                  style: Theme.of(context)
                      .accentTextTheme
                      .title
                      .copyWith(fontSize: widget.radius / 1.4),
                ),
              )),
          StreamBuilder(
              stream: heartbeatReceiverBloc.stream,
              builder: (context, AsyncSnapshot<Map<String, String>> snapshot) {
                Map<String, String> state;
                if (snapshot.hasData) {
                  state = snapshot.data;

                  if (state["user"] == widget.user.id) {
                    this.lastStatus = state["status"];
                  }

                  if (lastStatus == "online") {
                    return Container(
                        width: 12.0,
                        height: 12.0,
                        decoration: BoxDecoration(
                            color: Colors.green[400],
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1.5, color: const Color(0xFFFFFFFF))));
                  }
                }

                return Container();
              }),
        ]));
  }

  // Hashing username into a pastel color
  List<Color> _stringToColor(String str) {
    int hash = 0;

    str.runes.forEach((int rune) {
      hash = rune + ((hash << 5) - hash);
    });

    hash = hash % 360;

    return [
      HSLColor.fromAHSL(1.0, hash.toDouble(), 0.8, 0.4).toColor(),
      HSLColor.fromAHSL(1.0, hash.toDouble(), 0.8, 0.5).toColor()
    ];
  }
}
