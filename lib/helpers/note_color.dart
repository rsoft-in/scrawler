import 'package:bnotes/constants.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class NoteColor {
  static Color getColor(int code, bool isDark) {
    switch (code) {
      case 0:
        return isDark
            ? FlexColor.blueWhaleDarkPrimary.lighten()
            : FlexColor.blueWhaleDarkPrimary.lighten(30);
      case 1:
        return Color(0xFFFCECDD);
      case 2:
        return Color(0xffE4FBFF);
      case 3:
        return Color(0xffB6C9F0);
      case 4:
        return Color(0xffFFE8E8);
      case 5:
        return Color(0xffE1CCEC);
      default:
        return Colors.transparent;
    }
  }

  static int getCode(Color color) {
    if (color == Colors.transparent)
      return 0;
    else if (color == Color(0xFFFCECDD))
      return 1;
    else if (color == Color(0xffE4FBFF))
      return 2;
    else if (color == Color(0xffB6C9F0))
      return 3;
    else if (color == Color(0xffFFE8E8))
      return 4;
    else if (color == Color(0xffE1CCEC))
      return 5;
    else
      return 0;
  }
}
