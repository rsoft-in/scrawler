import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
      // useMaterial3: true,
      // colorSchemeSeed: Colors.black,
      inputDecorationTheme: inputDecorationTheme(),
      fontFamily: 'Inter',
      scaffoldBackgroundColor: kLightScaffold,
      // textTheme: const TextTheme(
      //   titleSmall: TextStyle(fontSize: 12.0),
      //   titleMedium: TextStyle(fontSize: 14.0),
      //   titleLarge: TextStyle(fontSize: 16.0),
      // ),
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
          borderRadius: BorderRadius.circular(10),
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
      )
      // cardTheme: CardTheme(
      //     shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(kGlobalBorderRadius),
      // )),
      // visualDensity: VisualDensity.adaptivePlatformDensity,
      // scaffoldBackgroundColor: Colors.white,
      // snackBarTheme: SnackBarThemeData(
      //   behavior: SnackBarBehavior.floating,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      // ),
      // inputDecorationTheme: inputDecorationTheme(),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ElevatedButton.styleFrom(
      //     elevation: 0,
      //     backgroundColor: Colors.black,
      //     padding: kButtonPadding,
      //     textStyle: const TextStyle(
      //       color: Colors.white,
      //       fontFamily: 'Raleway',
      //       fontSize: 16.0,
      //     ),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(kButtonBorderRadius),
      //     ),
      //   ),
      // ),
      // textButtonTheme: TextButtonThemeData(
      //   style: TextButton.styleFrom(
      //     foregroundColor: Colors.black,
      //     padding: kButtonPadding,
      //     textStyle: const TextStyle(
      //       color: Colors.white,
      //       fontFamily: 'Raleway',
      //       fontSize: 16.0,
      //     ),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(kButtonBorderRadius),
      //     ),
      //   ),
      // ),
      // outlinedButtonTheme: OutlinedButtonThemeData(
      //     style: OutlinedButton.styleFrom(
      //   padding: kButtonPadding,
      //   foregroundColor: Colors.black,
      //   textStyle: const TextStyle(
      //     fontFamily: 'Raleway',
      //     fontSize: 16.0,
      //   ),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(kButtonBorderRadius),
      //   ),
      // )),
      );
}

ThemeData themeDark() {
  return ThemeData(
      // colorSchemeSeed: kPrimaryColor,
      // useMaterial3: true,

      fontFamily: 'Inter',
      brightness: Brightness.dark,
      inputDecorationTheme: inputDecorationDarkTheme(),
      // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
      //     primary: kPrimaryColor,
      //     secondary: kAccentColor,
      //     brightness: Brightness.dark),

      // textTheme: const TextTheme(
      //   titleSmall: TextStyle(fontSize: 12.0),
      //   titleMedium: TextStyle(fontSize: 14.0),
      //   titleLarge: TextStyle(fontSize: 16.0),
      // ),
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
          borderRadius: BorderRadius.circular(10),
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
      )
      // cardTheme: CardTheme(
      //     shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(kGlobalBorderRadius),
      // )),
      // visualDensity: VisualDensity.adaptivePlatformDensity,
      // // scaffoldBackgroundColor: Colors.white,
      // snackBarTheme: SnackBarThemeData(
      //   behavior: SnackBarBehavior.floating,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      // ),
      // inputDecorationTheme: inputDecorationThemeDark(),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ElevatedButton.styleFrom(
      //     elevation: 0,
      //     backgroundColor: kPrimaryColor,
      //     padding: kButtonPadding,
      //     textStyle: const TextStyle(
      //       color: Colors.white,
      //       fontFamily: 'Raleway',
      //       fontSize: 16.0,
      //     ),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(kButtonBorderRadius),
      //     ),
      //   ),
      // ),
      // textButtonTheme: TextButtonThemeData(
      //   style: TextButton.styleFrom(
      //     foregroundColor: Colors.black,
      //     padding: kButtonPadding,
      //     textStyle: const TextStyle(
      //       color: Colors.white,
      //       fontFamily: 'Raleway',
      //       fontSize: 16.0,
      //     ),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(kButtonBorderRadius),
      //     ),
      //   ),
      // ),
      // outlinedButtonTheme: OutlinedButtonThemeData(
      //     style: OutlinedButton.styleFrom(
      //   padding: kButtonPadding,
      //   foregroundColor: Colors.white,
      //   textStyle: const TextStyle(
      //     fontFamily: 'Raleway',
      //     fontSize: 16.0,
      //   ),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(kButtonBorderRadius),
      //     side: const BorderSide(color: Colors.white),
      //   ),
      // )),
      // drawerTheme: const DrawerThemeData(
      //   backgroundColor: Colors.white,
      // ),
      );
}

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    filled: true,
    fillColor: kLightPrimary,
    suffixIconColor: kPrimaryColor,
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
  );
}

InputDecorationTheme inputDecorationDarkTheme() {
  return InputDecorationTheme(
    filled: true,
    fillColor: kDarkPrimary,
    suffixIconColor: kPrimaryColor,
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
  );
}
