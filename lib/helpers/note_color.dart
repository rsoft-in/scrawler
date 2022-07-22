import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class NoteColor {
  static Color getColor(int code, bool isDark) {
    switch (code) {
      case 0:
        return Color(0xFFFFDAA9);
      case 1:
        return Color(0xFFFFC7B3);
      case 2:
        return Color(0xFFFFDAA9);
      case 3:
        return Color(0xFFFFCEE6);
      case 4:
        return Color(0xFFEEC2FF);
      case 5:
        return Color(0xFFC8D3FF);
      case 6:
        return Colors.transparent;
      default:
        return Colors.transparent;
    }
  }

  static int getCode(Color color) {
    if (color == Colors.transparent)
      return 0;
    else if (color == Color(0xFFFFDAA9))
      return 1;
    else if (color == Color(0xFFFFC7B3))
      return 2;
    else if (color == Color(0xFFFFDAA9))
      return 3;
    else if (color == Color(0xFFFFCEE6))
      return 4;
    else if (color == Color(0xFFEEC2FF))
      return 5;
    else if (color == Color(0xFFC8D3FF))
      return 6;
    else
      return 0;
  }
}
