import "package:flutter/material.dart";

import "../../models/user_model.dart";
import "../../blocs/heartbeat_bloc.dart";

class UserAvatar extends StatefulWidget {
  final User user;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bloc;

  UserAvatar(
      {@required this.user,
      this.padding: const EdgeInsets.all(0.0),
      this.radius: 20.0})
      : bloc = HeartbeatReceiverBloc(user.id);

  @override
  State<StatefulWidget> createState() {
    return _UserAvatarState();
  }
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding,
        child: Stack(alignment: Alignment.bottomRight, children: <Widget>[
          CircleAvatar(
              backgroundColor: _stringToColor(widget.user.lastName),
              child: Text(
                widget.user.firstName[0].toUpperCase() +
                    widget.user.lastName[0].toUpperCase(),
                style: Theme.of(context).accentTextTheme.title,
              ),
              radius: widget.radius),
          StreamBuilder(
              stream: widget.bloc.colours,
              builder: (context, AsyncSnapshot<Color> snapshot) {
                Color colour = Color.fromARGB(255, 158, 158, 158);
                if (snapshot.hasData) {
                  colour = snapshot.data;
                }
                return Container(
                    width: 12.0,
                    height: 12.0,
                    decoration:
                        BoxDecoration(color: colour, shape: BoxShape.circle));
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
