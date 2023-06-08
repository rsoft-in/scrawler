import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: kPrimaryColor,
    inputDecorationTheme: inputDecorationTheme(),
    fontFamily: 'Raleway',
    // textTheme: const TextTheme(
    //   titleSmall: TextStyle(fontSize: 12.0),
    //   titleMedium: TextStyle(fontSize: 14.0),
    //   titleLarge: TextStyle(fontSize: 16.0),
    // ),
    // appBarTheme: const AppBarTheme(
    //   color: Colors.white,
    //   elevation: 1,
    //   iconTheme: IconThemeData(color: Colors.black),
    //   titleTextStyle: TextStyle(
    //     fontSize: 20.0,
    //     fontFamily: 'Raleway',
    //     color: Colors.black,
    //     fontWeight: FontWeight.w400,
    //   ),
    // ),
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
    colorSchemeSeed: kPrimaryColor,
    useMaterial3: true,
    fontFamily: 'Raleway',
    brightness: Brightness.dark,
    inputDecorationTheme: inputDecorationTheme(),
    // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
    //     primary: kPrimaryColor,
    //     secondary: kAccentColor,
    //     brightness: Brightness.dark),

    // textTheme: const TextTheme(
    //   titleSmall: TextStyle(fontSize: 12.0),
    //   titleMedium: TextStyle(fontSize: 14.0),
    //   titleLarge: TextStyle(fontSize: 16.0),
    // ),
    // appBarTheme: const AppBarTheme(
    //   color: Colors.black,
    //   elevation: 1,
    //   iconTheme: IconThemeData(color: Colors.black),
    //   titleTextStyle: TextStyle(
    //     fontSize: 20.0,
    //     fontFamily: 'Raleway',
    //     color: Colors.white,
    //     fontWeight: FontWeight.w400,
    //   ),
    // ),
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
    // contentPadding: kPaddingLarge,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kGlobalBorderRadius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kGlobalBorderRadius),
      borderSide: BorderSide.none,
    ),
    isDense: true,
    contentPadding: const EdgeInsets.all(15),
  );
}
