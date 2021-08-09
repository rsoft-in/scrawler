import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NoteColor {
  static Color getColor(int code, bool isDark) {
    switch (code) {
      case 0:
        return isDark ? Color(0xff1c1c1c) : Colors.white;
      case 1:
        return Color(0xFFA8EAD5);
      case 2:
        return Colors.red.shade200;
      case 3:
        return Colors.pink.shade200;
      case 4:
        return Colors.yellow.shade200;
      case 5:
        return Colors.blue.shade200;
      default:
        return Colors.transparent;
    }
  }

  static int getCode(Color color) {
    if (color == Colors.transparent)
      return 0;
    else if (color == Color(0xFFA8EAD5))
      return 1;
    else if (color == Colors.red.shade200)
      return 2;
    else if (color == Colors.pink.shade200)
      return 3;
    else if (color == Colors.yellow.shade200)
      return 4;
    else if (color == Colors.blue.shade200)
      return 5;
    else
      return 0;
  }
}
