import 'package:flutter/material.dart';
import 'package:scrawler/widgets/color_palette_button.dart';

import '../helpers/note_color.dart';

class ScrawlColorPicker extends StatelessWidget {
  const ScrawlColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 160),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Select Color'),
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
      ),
    );
  }
}
