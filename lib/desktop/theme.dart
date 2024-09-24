import 'package:flutter/material.dart';
import 'package:scrawler/helpers/constants.dart';

ThemeData theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimaryColor,
    dynamicSchemeVariant: DynamicSchemeVariant.content,
  ),
  scaffoldBackgroundColor: const Color(0xFFefeff0),
  splashFactory: NoSplash.splashFactory,
  listTileTheme: listTileThemeData(),
  elevatedButtonTheme: elevatedButtonThemeData(),
  filledButtonTheme: filledButtonThemeData(),
  outlinedButtonTheme: outlinedButtonThemeData(),
  textButtonTheme: textButtonThemeData(),
  dialogTheme: dialogTheme(),
  dropdownMenuTheme: dropdownMenuThemeData(),
  popupMenuTheme: popupMenuThemeData(),
  inputDecorationTheme: inputDecorationTheme(),
);

ThemeData themeDark = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimaryColor,
    brightness: Brightness.dark,
    dynamicSchemeVariant: DynamicSchemeVariant.content,
  ),
  splashFactory: NoSplash.splashFactory,
  listTileTheme: listTileThemeData(),
  elevatedButtonTheme: elevatedButtonThemeData(),
  filledButtonTheme: filledButtonThemeData(),
  outlinedButtonTheme: outlinedButtonThemeData(),
  textButtonTheme: textButtonThemeData(),
  dialogTheme: dialogTheme(),
  dropdownMenuTheme: dropdownMenuThemeData(),
  popupMenuTheme: popupMenuThemeData(),
  inputDecorationTheme: inputDecorationTheme(),
);

// ListTile
ListTileThemeData listTileThemeData() {
  return const ListTileThemeData(
    dense: true,
  );
}

// ElevatedButton
ElevatedButtonThemeData elevatedButtonThemeData() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kGlobalBorderRadius),
      ),
    ),
  );
}

// FilledButton
FilledButtonThemeData filledButtonThemeData() {
  return FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kGlobalBorderRadius),
      ),
    ),
  );
}

// OutlinedButton
OutlinedButtonThemeData outlinedButtonThemeData() {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kGlobalBorderRadius),
      ),
    ),
  );
}

// TextButton
TextButtonThemeData textButtonThemeData() {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kGlobalBorderRadius),
      ),
    ),
  );
}

// DialogTheme
DialogTheme dialogTheme() {
  return DialogTheme(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kGlobalBorderRadius)),
  );
}

// DropdownMenu
DropdownMenuThemeData dropdownMenuThemeData() {
  return DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kGlobalBorderRadius),
      ),
    ),
  );
}

// PopupMenu
PopupMenuThemeData popupMenuThemeData() {
  return PopupMenuThemeData(
    position: PopupMenuPosition.under,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kGlobalBorderRadius),
    ),
  );
}

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    filled: true,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    isDense: true,
    hintStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
    counterStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
    labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
    helperStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(25),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 2),
      borderRadius: BorderRadius.circular(25),
    ),
  );
}
