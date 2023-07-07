import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    inputDecorationTheme: inputDecorationTheme(),
    fontFamily: 'Inter',
    scaffoldBackgroundColor: kLightScaffold,
    iconTheme: const IconThemeData(color: kDarkPrimary),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontFamily: 'Inter',
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      elevation: 0,
      color: kLightSecondary,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: kLightStroke, width: 2),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: kLightSecondary,
      elevation: 0,
      surfaceTintColor: kLightSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    listTileTheme: ListTileThemeData(
      selectedColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    dialogTheme: DialogTheme(
      elevation: 0,
      backgroundColor: kLightSecondary,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: kLightStroke, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: kLightSecondary,
        border: Border.all(
          color: kLightStroke,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      textStyle: const TextStyle(color: Colors.black),
    ),
    cardTheme: CardTheme(
      color: kLightPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: kLightStroke, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}

ThemeData themeDark() {
  return ThemeData(
    fontFamily: 'Inter',
    brightness: Brightness.dark,
    iconTheme: const IconThemeData(color: kLightPrimary),
    inputDecorationTheme: inputDecorationDarkTheme(),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontFamily: 'Inter',
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: kDarkSecondary,
      elevation: 0,
      surfaceTintColor: kDarkSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      elevation: 0,
      color: kDarkSecondary,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: kDarkStroke, width: 2),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      selectedColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    dialogTheme: DialogTheme(
      elevation: 0,
      backgroundColor: kDarkSecondary,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: kDarkStroke, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: kDarkSecondary,
        border: Border.all(
          color: kDarkStroke,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      textStyle: const TextStyle(color: Colors.white),
    ),
    cardTheme: CardTheme(
      color: kDarkPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: kDarkStroke, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    filled: true,
    fillColor: kLightPrimary,
    suffixIconColor: kDarkPrimary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: kLightStroke, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: kLightStroke, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: kLightStroke, width: 2),
    ),
    isDense: true,
    contentPadding: const EdgeInsets.all(15),
    prefixIconColor: kDarkPrimary,
  );
}

InputDecorationTheme inputDecorationDarkTheme() {
  return InputDecorationTheme(
    filled: true,
    fillColor: kDarkPrimary,
    suffixIconColor: kLightPrimary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: kDarkStroke, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: kDarkStroke, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: kDarkStroke, width: 2),
    ),
    isDense: true,
    contentPadding: const EdgeInsets.all(15),
    prefixIconColor: kLightPrimary,
  );
}
