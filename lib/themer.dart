import 'package:flutter/material.dart';

const primaryColor = const Color(0xFF29C3EF);
const primaryColorDark = const Color(0xFF3270F8);
const accentColor = const Color(0xFF103168);

ThemeData buildTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
      accentColor: accentColor,
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      highlightColor: accentColor,
      textTheme: buildTextTheme(base.textTheme),
      primaryTextTheme: buildTextTheme(base.textTheme),
      accentTextTheme: buildTextTheme(base.textTheme),
      iconTheme: buildIconTheme(),
      primaryIconTheme: buildIconTheme(),
      accentIconTheme: buildIconTheme());
}

TextTheme buildTextTheme(TextTheme base) {
  return base
      .copyWith(
          display1: base.display1
              .copyWith(fontSize: 18.0, fontWeight: FontWeight.w500),
          body2:
              base.body2.copyWith(fontSize: 16.0, fontWeight: FontWeight.w500),
          body1:
              base.body1.copyWith(fontSize: 12.0, fontWeight: FontWeight.w400))
      .apply(
          fontFamily: 'Inter',
          displayColor: Colors.white,
          bodyColor: accentColor);
}

IconThemeData buildIconTheme() {
  return IconThemeData(color: Colors.white, opacity: 1.0, size: 24.0);
}
