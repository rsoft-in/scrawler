import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

const FlexScheme usedScheme = FlexScheme.jungle;

ThemeData theme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
        .copyWith(primary: kPrimaryColor, secondary: kAccentColor),
    fontFamily: 'Raleway',
    textTheme: TextTheme(
      titleSmall: TextStyle(fontSize: 12.0),
      titleMedium: TextStyle(fontSize: 14.0),
      titleLarge: TextStyle(fontSize: 16.0),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        fontSize: 20.0,
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
    inputDecorationTheme: InputDecorationTheme(
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
      floatingLabelStyle: TextStyle(color: kPrimaryColor),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: kInputDecorationPadding,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        padding: kButtonPadding,
        textStyle: TextStyle(
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
        primary: Colors.black,
        padding: kButtonPadding,
        textStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Raleway',
          fontSize: 18.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButtonBorderRadius),
        ),
      ),
    ),
  );
}

ThemeData themeDark() {
  return FlexThemeData.dark(
    scheme: usedScheme,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 0,
    appBarOpacity: 0.5,
    appBarStyle: FlexAppBarStyle.background,
    transparentStatusBar: true,
    darkIsTrueBlack: true,
    tooltipsMatchBackground: true,
    // fontFamily: 'Raleway',
    subThemesData: FlexSubThemesData(
      elevatedButtonRadius: 10.0,
      textButtonRadius: 10.0,
      outlinedButtonRadius: 10.0,
      cardRadius: 10.0,
      cardElevation: 1,
      bottomSheetRadius: 10,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
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
