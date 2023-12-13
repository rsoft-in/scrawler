import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:flutter/material.dart';

/// Returns a boolean if we are on a medium or larger screen. Used to
/// build adaptive and responsive layouts.
bool isDisplayDesktop(BuildContext context) =>
    getWindowType(context) >= AdaptiveWindowType.medium;

/// Returns true if the window size is medium size. Used to build adaptive and responsive layouts.
bool isDisplaySmallDesktop(BuildContext context) {
  return getWindowType(context) == AdaptiveWindowType.small;
}

ScreenSize getScreenSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width <= 480) {
    return ScreenSize.small;
  } else if (width > 480 && width <= 768) {
    return ScreenSize.medium;
  } else {
    return ScreenSize.large;
  }
}
