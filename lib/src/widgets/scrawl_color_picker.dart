import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:forui/widgets/dialog.dart';
import 'package:scrawler/src/widgets/color_palette_button.dart';

import '../helpers/note_color.dart';

class ScrawlColorPicker extends StatelessWidget {
  const ScrawlColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return FDialog.raw(
      builder: (context, style) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('select_color'.tr()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ColorPaletteButton(
                        onTap: () => Navigator.pop(context, 1),
                        color: NoteColor.getColor(1, false),
                        isSelected: false),
                    ColorPaletteButton(
                        onTap: () => Navigator.pop(context, 2),
                        color: NoteColor.getColor(2, false),
                        isSelected: false),
                    ColorPaletteButton(
                        onTap: () => Navigator.pop(context, 3),
                        color: NoteColor.getColor(3, false),
                        isSelected: false),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ColorPaletteButton(
                        onTap: () => Navigator.pop(context, 4),
                        color: NoteColor.getColor(4, false),
                        isSelected: false),
                    ColorPaletteButton(
                        onTap: () => Navigator.pop(context, 5),
                        color: NoteColor.getColor(5, false),
                        isSelected: false),
                    ColorPaletteButton(
                        onTap: () => Navigator.pop(context, 6),
                        color: NoteColor.getColor(6, false),
                        isSelected: false),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context, 0),
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Icon(Icons.block),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
