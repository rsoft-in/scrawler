import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: kPrimaryColor,
    accentColor: kAccentColor,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      textTheme:
          TextTheme(headline6: TextStyle(fontSize: 20.0, color: Colors.black)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: kPrimaryColor, foregroundColor: Colors.white),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.white,
    dividerColor: Colors.black,
  );
}

ThemeData themeDark() {
  return ThemeData(
    brightness: Brightness.dark,
    accentColor: kAccentColor,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      textTheme:
          TextTheme(headline6: TextStyle(fontSize: 20.0, color: Colors.white)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: kPrimaryColor, foregroundColor: Colors.white),
    dividerColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
