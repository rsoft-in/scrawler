import 'package:flutter/material.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:universal_platform/universal_platform.dart';

ThemeData theme(BuildContext context, Color appColor) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: appColor),
    listTileTheme: listTileThemeData(),
    elevatedButtonTheme: elevatedButtonThemeData(),
    filledButtonTheme: filledButtonThemeData(),
    outlinedButtonTheme: outlinedButtonThemeData(context),
    textButtonTheme: textButtonThemeData(),
    dropdownMenuTheme: dropdownMenuThemeData(),
    popupMenuTheme: popupMenuThemeData(),
    inputDecorationTheme: inputDecorationTheme(),
    searchBarTheme: _searchBarThemeData(context),
    searchViewTheme: searchViewThemeData(),
    dialogTheme: dialogThemeData(),
  );
}

ThemeData themeDark(BuildContext context, Color appColor) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: appColor,
      brightness: Brightness.dark,
    ),
    listTileTheme: listTileThemeData(),
    elevatedButtonTheme: elevatedButtonThemeData(),
    filledButtonTheme: filledButtonThemeData(),
    outlinedButtonTheme: outlinedButtonThemeData(context),
    textButtonTheme: textButtonThemeData(),
    dropdownMenuTheme: dropdownMenuThemeData(),
    popupMenuTheme: popupMenuThemeData(),
    inputDecorationTheme: inputDecorationTheme(),
    searchBarTheme: _searchBarThemeData(context),
    searchViewTheme: searchViewThemeData(),
    dialogTheme: dialogThemeData(),
  );
}

// ListTile
ListTileThemeData listTileThemeData() {
  return ListTileThemeData(
    dense: UniversalPlatform.isDesktopOrWeb ? true : false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(16),
    ),
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
OutlinedButtonThemeData outlinedButtonThemeData(BuildContext context) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kGlobalBorderRadius),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
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
DialogThemeData dialogThemeData() {
  return DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kGlobalBorderRadius),
    ),
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
    menuPadding: const EdgeInsets.all(0),
  );
}

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    isDense: true,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(kGlobalBorderRadius),
    ),
  );
}

SearchBarThemeData _searchBarThemeData(BuildContext context) {
  return SearchBarThemeData(
    padding: const WidgetStatePropertyAll<EdgeInsets>(
      EdgeInsets.symmetric(horizontal: 16.0),
    ),
    constraints: const BoxConstraints(maxHeight: 50, minHeight: 40),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kGlobalBorderRadius),
      ),
    ),
    elevation: const WidgetStatePropertyAll(0),
    // side: WidgetStatePropertyAll(
    //   BorderSide(
    //     width: 1.5,
    //     color: Theme.of(context).colorScheme.outlineVariant,
    //   ),
    // ),
    // backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
  );
}

SearchViewThemeData searchViewThemeData() {
  return SearchViewThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kGlobalBorderRadius),
    ),
    side: BorderSide.none,
  );
}

TabBarTheme tabBarTheme(BuildContext context) {
  return TabBarTheme(
    indicator: BoxDecoration(
      color: Theme.of(context).colorScheme.surface.withAlpha(20),
      borderRadius: BorderRadius.circular(20),
    ),
    indicatorSize: TabBarIndicatorSize.tab,
    dividerHeight: 0,
    tabAlignment: TabAlignment.start,
  );
}
