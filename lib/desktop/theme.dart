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
