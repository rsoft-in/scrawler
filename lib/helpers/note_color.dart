import 'package:flutter/material.dart';

class NoteColor {
  static Color getColor(int code, bool isDark) {
    switch (code) {
      case 1:
        return const Color(0xFFFFDAA9);
      case 2:
        return const Color(0xFFFFC7B3);
      case 3:
        return const Color(0xFFFFDAA9);
      case 4:
        return const Color(0xFFFFCEE6);
      case 5:
        return const Color(0xFFEEC2FF);
      case 6:
        return const Color(0xFFC8D3FF);
      case 0:
        return Colors.transparent;
      default:
        return Colors.transparent;
    }
  }

  static int getCode(Color color) {
    if (color == Colors.transparent) {
      return 0;
    } else if (color == const Color(0xFFFFDAA9)) {
      return 1;
    } else if (color == const Color(0xFFFFC7B3)) {
      return 2;
    } else if (color == const Color(0xFFFFDAA9)) {
      return 3;
    } else if (color == const Color(0xFFFFCEE6)) {
      return 4;
    } else if (color == const Color(0xFFEEC2FF)) {
      return 5;
    } else if (color == const Color(0xFFC8D3FF)) {
      return 6;
    } else {
      return 0;
    }
  }
}
