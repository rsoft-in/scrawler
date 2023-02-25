import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

const FlexScheme usedScheme = FlexScheme.jungle;

ThemeData theme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
        .copyWith(primary: kPrimaryColor, secondary: kAccentColor),
    fontFamily: 'Raleway',
    textTheme: const TextTheme(
      titleSmall: TextStyle(fontSize: 12.0),
      titleMedium: TextStyle(fontSize: 14.0),
      titleLarge: TextStyle(fontSize: 16.0),
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontFamily: 'Raleway',
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.white,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    ),
    inputDecorationTheme: inputDecorationTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.black,
        padding: kButtonPadding,
        textStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Raleway',
          fontSize: 16.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButtonBorderRadius),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        padding: kButtonPadding,
        textStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Raleway',
          fontSize: 16.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButtonBorderRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      padding: kButtonPadding,
      foregroundColor: Colors.black,
      textStyle: const TextStyle(
        fontFamily: 'Raleway',
        fontSize: 16.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kButtonBorderRadius),
      ),
    )),
  );
}

ThemeData themeDark() {
  return ThemeData(
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
        primary: kPrimaryColor,
        secondary: kAccentColor,
        brightness: Brightness.dark),
    fontFamily: 'Raleway',
    textTheme: const TextTheme(
      titleSmall: TextStyle(fontSize: 12.0),
      titleMedium: TextStyle(fontSize: 14.0),
      titleLarge: TextStyle(fontSize: 16.0),
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.black,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontFamily: 'Raleway',
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // scaffoldBackgroundColor: Colors.white,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    ),
    inputDecorationTheme: inputDecorationThemeDark(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        padding: kButtonPadding,
        textStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Raleway',
          fontSize: 16.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButtonBorderRadius),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        padding: kButtonPadding,
        textStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Raleway',
          fontSize: 16.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButtonBorderRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      padding: kButtonPadding,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontFamily: 'Raleway',
        fontSize: 16.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kButtonBorderRadius),
        side: const BorderSide(color: Colors.white),
      ),
    )),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
    ),
  );
}

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kInputDecorationBorderRadius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kInputDecorationBorderRadius),
      borderSide: BorderSide.none,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kInputDecorationBorderRadius),
      borderSide: BorderSide.none,
    ),
    prefixIconColor: kPrimaryColor,
    suffixIconColor: kPrimaryColor,
    floatingLabelStyle: const TextStyle(color: kPrimaryColor),
    filled: true,
    fillColor: Colors.grey.shade50,
    contentPadding: kInputDecorationPadding,
  );
}

InputDecorationTheme inputDecorationThemeDark() {
  return InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kInputDecorationBorderRadius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kInputDecorationBorderRadius),
      borderSide: BorderSide.none,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kInputDecorationBorderRadius),
      borderSide: BorderSide.none,
    ),
    prefixIconColor: kAccentColor,
    suffixIconColor: kAccentColor,
    floatingLabelStyle: const TextStyle(color: kAccentColor),
    filled: true,
    fillColor: Colors.grey.shade800,
    contentPadding: kInputDecorationPadding,
  );
}
