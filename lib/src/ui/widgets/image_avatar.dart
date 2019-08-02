import "package:flutter/material.dart";
import "dart:io";

import "../../blocs/heartbeat_bloc.dart";
import "../../resources/picture_api_provider.dart";
import "../../models/user_model.dart";
import "../../models/conversation_model.dart";

class ImageAvatarInfo {
  final String firstName;
  final String lastName;
  final String coverPic;
  final String heartbeatId;
  final bool isHeartbeat;

  ImageAvatarInfo(
      {@required this.lastName,
      this.firstName: "",
      this.coverPic: "",
      this.isHeartbeat: false,
      this.heartbeatId: ""});

  factory ImageAvatarInfo.fromUser(User user) {
    return ImageAvatarInfo(
        firstName: user.firstName,
        lastName: user.lastName,
        isHeartbeat: true,
        heartbeatId: user.id,
        coverPic: user.profilePic);
  }

  factory ImageAvatarInfo.fromConversation(Conversation conversation) {
    return ImageAvatarInfo(
        lastName: conversation.title, coverPic: conversation.picture);
  }
}

class ImageAvatar extends StatefulWidget {
  final ImageAvatarInfo info;
  final EdgeInsetsGeometry padding;
  final double radius;

  ImageAvatar(
      {@required this.info,
      this.padding: const EdgeInsets.all(0.0),
      this.radius: 20.0});

  @override
  State<StatefulWidget> createState() {
    return _ImageAvatarState();
  }
}

class _ImageAvatarState extends State<ImageAvatar> {
  String lastStatus;
  String firstLetter;
  String lastLetter;

  List<Color> profileColors;
  File profilePic;

  @override
  initState() {
    super.initState();

    lastStatus = (widget.info.isHeartbeat)
        ? heartbeatReceiverBloc.getLastStatus(widget.info.heartbeatId)
        : "";

    if (widget.info.coverPic == "") {
      firstLetter =
          (widget.info.firstName.isEmpty) ? '' : widget.info.firstName[0];
      lastLetter =
          (widget.info.lastName.isEmpty) ? '' : widget.info.lastName[0];
      profileColors = _stringToColor(widget.info.lastName);
    } else {
      // Get picture
      pictureApiProvider.getPicture(widget.info.coverPic).then((File profile) {
        setState(() {
          profilePic = profile;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding,
        child: Stack(alignment: Alignment.bottomRight, children: <Widget>[
          (widget.info.coverPic == "")
              ? Container(
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
                  ))
              : (profilePic != null)
                  ? CircleAvatar(
                      radius: widget.radius,
                      backgroundImage: FileImage(profilePic))
                  : Container(),
          StreamBuilder(
              stream: heartbeatReceiverBloc.stream,
              builder: (context, AsyncSnapshot<Map<String, String>> snapshot) {
                Map<String, String> state;
                if (snapshot.hasData) {
                  state = snapshot.data;

                  if (state["user"] == widget.info.heartbeatId) {
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
