import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    primarySwatch: Colors.red,
    primaryColor: kPrimaryColor,
    accentColor: kAccentColor,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.black),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      textTheme:
          TextTheme(headline6: TextStyle(fontSize: 20.0, color: Colors.black)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: kPrimaryColor, foregroundColor: Colors.white),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.white,
    dividerColor: Colors.black,
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.black,
        backgroundColor: Colors.black12,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    ),
    // inputDecorationTheme: inputDecorationTheme(),
  );
}

ThemeData themeDark() {
  SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.red,
  );
  return ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.red,
    accentColor: kAccentColor,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        
      ),
      textTheme:
          TextTheme(headline6: TextStyle(fontSize: 20.0, color: Colors.white)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: kPrimaryColor, foregroundColor: Colors.white),
    dividerColor: Colors.white,
    bottomAppBarColor: kSecondaryDark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    cardTheme: CardTheme(
      color: kSecondaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.black26,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    ),
    scaffoldBackgroundColor: Color(0xFF121212),
    // inputDecorationTheme: inputDecorationTheme(),
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    borderSide: BorderSide(width: 0.5, color: kBorderColor),
  );
  OutlineInputBorder focusedInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    borderSide: BorderSide(width: 0.5, color: kPrimaryColor),
  );
  return InputDecorationTheme(
    // contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
    enabledBorder: outlineInputBorder,
    focusedBorder: focusedInputBorder,
    border: outlineInputBorder,
    filled: true,
  );
}
