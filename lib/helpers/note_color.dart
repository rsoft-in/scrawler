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
    return colorSet
        .firstWhere(
          (set) => set.code == code,
          orElse: () => colorSet[6],
        )
        .color;
  }

  static int getCode(Color color) {
    return colorSet
        .firstWhere(
          (set) => set.color == color,
          orElse: () => colorSet[6],
        )
        .code;
  }
}
