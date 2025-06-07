import 'package:flutter/material.dart';

class AvatarColor {
  static final List<Color> _colors = [
    const Color(0xFF00bdbd),
    const Color(0xFFdb6767),
    const Color(0xFFde9968),
    const Color(0xFFdeca68),
    const Color(0xFFb9de68),
    const Color(0xFF5ec259),
    const Color(0xFF59c27a),
    const Color(0xFF598cc2),
    const Color(0xFF494ea6),
    const Color(0xFF905ed1),
    const Color(0xFFc45ed1),
    const Color(0xFFd15e9b),
    const Color(0xFFd15e81),
    const Color(0xFFd15e60),
  ];

  static List<Color> get allColors {
    return _colors;
  }

  static Color getColor(String text) {
    if (text.length > 1) {
      final int color = (text.hashCode % AvatarColor.allColors.length);
      return AvatarColor.allColors.elementAt(color);
    } else {
      return const Color(0xFFEEEEEE);
    }
  }
}
