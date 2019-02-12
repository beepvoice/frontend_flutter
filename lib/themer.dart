import 'package:flutter/material.dart';

const primaryColor = const Color(0xFF29C3EF);
const primaryColorDark = const Color(0xFF3270F8);
const accentColor = const Color(0xFF103168);
const highlightColor = const Color(0xFFC6DCFC);
const indicatorColor = const Color(0xFFFF7865);

ThemeData buildTheme() {
  final ThemeData base = ThemeData.light();
  final TextTheme textBase = buildTextTheme(base.textTheme);

  return base.copyWith(
      accentColor: accentColor,
      primaryColor: primaryColor,
      primaryColorLight: Colors.white,
      primaryColorDark: primaryColorDark,
      indicatorColor: indicatorColor,
      textTheme: textBase,
      primaryTextTheme: textBase,
      accentTextTheme: buildAltTextTheme(textBase),
      iconTheme: buildIconTheme(),
      primaryIconTheme: buildIconTheme(),
      accentIconTheme: buildIconTheme());
}

TextTheme buildTextTheme(TextTheme base) {
  return base
      .copyWith(
          display2: base.display2
              .copyWith(fontSize: 18.0, fontWeight: FontWeight.w400),
          display1: base.display1
              .copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
          title:
              base.title.copyWith(fontSize: 16.0, fontWeight: FontWeight.w500),
          subtitle: base.subtitle
              .copyWith(fontSize: 12.0, fontWeight: FontWeight.w400),
          body2:
              base.body2.copyWith(fontSize: 16.0, fontWeight: FontWeight.w500),
          body1:
              base.body1.copyWith(fontSize: 12.0, fontWeight: FontWeight.w400))
      .apply(
          fontFamily: 'Inter',
          displayColor: accentColor,
          bodyColor: accentColor);
}

TextTheme buildAltTextTheme(TextTheme base) {
  return base.apply(displayColor: Colors.white, bodyColor: Colors.white);
}

IconThemeData buildIconTheme() {
  return IconThemeData(color: Colors.white, opacity: 1.0, size: 24.0);
}
