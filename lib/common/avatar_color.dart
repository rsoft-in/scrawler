import 'package:flutter/material.dart';

class AvatarColor {
  static List<Color> _colors = [
    new Color(0xFF00bdbd),
    new Color(0xFFdb6767),
    new Color(0xFFde9968),
    new Color(0xFFdeca68),
    new Color(0xFFb9de68),
    new Color(0xFF5ec259),
    new Color(0xFF59c27a),
    new Color(0xFF598cc2),
    new Color(0xFF494ea6),
    new Color(0xFF905ed1),
    new Color(0xFFc45ed1),
    new Color(0xFFd15e9b),
    new Color(0xFFd15e81),
    new Color(0xFFd15e60),
  ];

  static List<Color> get allColors {
    return _colors;
  }

  static Color getColor(String text) {
    if (text.length > 1) {
      final int color = (text.hashCode % AvatarColor.allColors.length);
      return AvatarColor.allColors.elementAt(color);
    } else {
      return new Color(0xFFEEEEEE);
    }
  }
}
