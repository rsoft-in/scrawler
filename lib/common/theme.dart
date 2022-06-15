import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

const FlexScheme usedScheme = FlexScheme.jungle;

ThemeData theme() {
  return FlexThemeData.light(
    scheme: usedScheme,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 0,
    appBarOpacity: 0.5,
    appBarStyle: FlexAppBarStyle.background,
    // useSubThemes: true,
    transparentStatusBar: true,
    lightIsWhite: true,
    fontFamily: 'Raleway',
    subThemesData: FlexSubThemesData(
      elevatedButtonRadius: 10.0,
      textButtonRadius: 10.0,
      outlinedButtonRadius: 10.0,
      cardRadius: 10.0,
      cardElevation: .5,
      bottomNavigationBarElevation: 25,
      bottomSheetRadius: 10,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
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
    fontFamily: 'Raleway',
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
