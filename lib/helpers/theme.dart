import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimaryColor,
    ),
    useMaterial3: true,
    fontFamily: 'Inter',
    inputDecorationTheme: inputDecorationTheme(),
    appBarTheme: const AppBarTheme(centerTitle: false),
    iconTheme: const IconThemeData(
        color: Colors.black, fill: 0, weight: 400, opticalSize: 48),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
      ),
    ),
  );
}

ThemeData themeDark() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: kPrimaryColor, brightness: Brightness.dark),
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: Colors.black,
    appBarTheme:
        const AppBarTheme(elevation: 0, backgroundColor: Colors.transparent),
    iconTheme: const IconThemeData(
        color: Colors.white, fill: 0, weight: 400, opticalSize: 48),
    inputDecorationTheme: inputDecorationTheme(),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          side: const BorderSide(color: Colors.black, width: 0.5),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
      ),
    ),
  );
}

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
      borderSide: const BorderSide(width: 0.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
      borderSide: const BorderSide(width: 0.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
      borderSide: const BorderSide(width: 0.5),
    ),
    isDense: true,
  );
}
