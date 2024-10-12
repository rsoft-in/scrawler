import 'package:flutter/material.dart';

class ColorSet {
  Color color;
  int code;
  ColorSet(this.code, this.color);
}

class NoteColor {
  static List<ColorSet> colorSet = [
    ColorSet(1, const Color(0xFFBCD4B6)),
    ColorSet(2, const Color(0xFFFFC7B3)),
    ColorSet(3, const Color(0xFFFFDAA9)),
    ColorSet(4, const Color(0xFFFFCEE6)),
    ColorSet(5, const Color(0xFFEEC2FF)),
    ColorSet(6, const Color(0xFFC8D3FF)),
    ColorSet(0, Colors.transparent),
  ];

  static Color getColor(int code, bool isDark) {
    switch (code) {
      case 1:
        return const Color(0xFFBCD4B6);
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
    } else if (color == const Color(0xFFBCD4B6)) {
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
