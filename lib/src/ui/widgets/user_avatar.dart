import "package:flutter/material.dart";

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
  HeartbeatReceiverBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = HeartbeatReceiverBloc(widget.user.id);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String firstName =
        (widget.user.firstName.isEmpty) ? '' : widget.user.firstName[0];
    String lastName =
        (widget.user.lastName.isEmpty) ? '' : widget.user.lastName[0];

    return Padding(
        padding: widget.padding,
        child: Stack(alignment: Alignment.bottomRight, children: <Widget>[
          CircleAvatar(
              backgroundColor: _stringToColor(widget.user.lastName),
              child: Text(
                firstName.toUpperCase() + lastName.toUpperCase(),
                style: Theme.of(context)
                    .accentTextTheme
                    .title
                    .copyWith(fontSize: widget.radius / 1.2),
              ),
              radius: widget.radius),
          StreamBuilder(
              stream: bloc.colours,
              builder: (context, AsyncSnapshot<String> snapshot) {
                String state;
                if (snapshot.hasData) {
                  state = snapshot.data;
                  if (state == "online") {
                    return Container(
                        width: 12.0,
                        height: 12.0,
                        decoration: BoxDecoration(
                            color: Colors.green[400], shape: BoxShape.circle));
                  }
                }

                return Container();
              }),
        ]));
  }

  // Hashing username into a pastel color
  Color _stringToColor(String str) {
    int hash = 0;

    str.runes.forEach((int rune) {
      hash = rune + ((hash << 5) - hash);
    });

    hash = hash % 360;

    return HSLColor.fromAHSL(1.0, hash.toDouble(), 0.8, 0.4).toColor();
  }
}
