import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

const FlexScheme usedScheme = FlexScheme.blueWhale;

ThemeData theme() {
  return FlexThemeData.light(
    scheme: usedScheme,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 0,
    appBarOpacity: 0.5,
    appBarStyle: FlexAppBarStyle.surface,
    useSubThemes: true,
    transparentStatusBar: true,
    fontFamily: 'Raleway',
    subThemesData: FlexSubThemesData(
      elevatedButtonRadius: 25.0,
      textButtonRadius: 25.0,
      outlinedButtonRadius: 25.0,
      cardRadius: 10.0,
      cardElevation: .5,
      bottomNavigationBarOpacity: 0.5,
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
    appBarStyle: FlexAppBarStyle.surface,
    useSubThemes: true,
    transparentStatusBar: true,
    darkIsTrueBlack: true,
    fontFamily: 'Raleway',
    subThemesData: FlexSubThemesData(
      elevatedButtonRadius: 25.0,
      textButtonRadius: 25.0,
      outlinedButtonRadius: 25.0,
      cardRadius: 10.0,
      cardElevation: 1,
      bottomNavigationBarOpacity: 0.5,
      inputDecoratorBorderType: FlexInputBorderType.outline,
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
