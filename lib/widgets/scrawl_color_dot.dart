import 'package:flutter/material.dart';

import '../helpers/note_color.dart';

class ScrawlColorDot extends StatelessWidget {
  final int colorCode;
  const ScrawlColorDot({Key? key, required this.colorCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color: NoteColor.getColor(colorCode, false),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
