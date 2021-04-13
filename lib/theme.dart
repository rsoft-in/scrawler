import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: kPrimaryColor,
    accentColor: kAccentColor,
    appBarTheme: AppBarTheme(
      color: Colors.grey[100],
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      textTheme:
          TextTheme(headline6: TextStyle(fontSize: 20.0, color: Colors.black)),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.grey[100],
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
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
