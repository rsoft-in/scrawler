import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      primary: Colors.black,
    ),
    useMaterial3: true,
    fontFamily: 'Inter',
    inputDecorationTheme: inputDecorationTheme(),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        backgroundColor: kDarkPrimary,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: kDarkStroke, width: 1),
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          side: const BorderSide(color: kDarkPrimary, width: 1),
        ),
      ),
    ),
    cardTheme: CardTheme(color: Colors.grey.shade100, elevation: 0),
  );
}

ThemeData themeDark() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black,
        primary: Colors.white,
        brightness: Brightness.dark),
    useMaterial3: true,
    fontFamily: 'Inter',
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
  );
}

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
      borderSide: const BorderSide(color: kDarkStroke, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
      borderSide: const BorderSide(color: kDarkStroke, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
      borderSide: const BorderSide(color: kDarkStroke, width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
  );
}
