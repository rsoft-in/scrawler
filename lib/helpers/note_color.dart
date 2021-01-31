import 'package:flutter/material.dart';

class NoteColor {
  static Color getColor(int code) {
    switch (code) {
      case 0:
        return Color(0xFFA8EAD5);
      case 1:
        return Colors.red.shade200;
      case 2:
        return Colors.pink.shade200;
      case 3:
        return Colors.yellow.shade200;
      case 4:
        return Colors.blue.shade200;
      default:
        return Color(0xFFA8EAD5);
    }
  }

  static int getCode(Color color) {
    if (color == Color(0xFFA8EAD5))
      return 0;
    else if (color == Colors.red.shade200)
      return 1;
    else if (color == Colors.pink.shade200)
      return 2;
    else if (color == Colors.yellow.shade200)
      return 3;
    else if (color == Colors.blue.shade200)
      return 4;
    else
      return 0;
  }
}
