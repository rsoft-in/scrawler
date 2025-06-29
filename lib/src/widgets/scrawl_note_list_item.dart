import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/helpers/note_color.dart';
import 'package:scrawler/src/helpers/utility.dart';
import 'package:scrawler/src/models/notes.dart';

// ignore: must_be_immutable
class NoteListItem extends StatefulWidget {
  Notes note;
  int selectedIndex;
  bool isSelected = false;
  VoidCallback? onTap;
  VoidCallback? onLongPress;
  NoteListItem(
      {super.key,
      required this.note,
      required this.selectedIndex,
      required this.isSelected,
      this.onTap,
      this.onLongPress});

  @override
  State<NoteListItem> createState() => _NoteListItemState();
}

class _NoteListItemState extends State<NoteListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 10.0,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Material(
          child: Container(
            decoration: BoxDecoration(
              border: widget.isSelected
                  ? Border.all(width: 2)
                  : Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  ),
                  padding: EdgeInsets.all(16),
                  child: Markdown(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    data: widget.note.noteText,
                    // child: Text(
                    //   widget.note.noteText,
                    //   style: Theme.of(context).textTheme.bodyLarge,
                    // ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 50,
                      decoration: BoxDecoration(
                        color: NoteColor.getColor(widget.note.noteColor, false),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    kHSpace,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.note.noteTitle,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              formatDateTime(widget.note.noteDate),
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.note.noteLabel.isNotEmpty)
                      Chip(
                        label: Text(
                          '${(widget.note.noteLabel).split(',')[0]}${widget.note.noteLabel.contains(',') ? '...' : ''}',
                          style: const TextStyle(fontSize: 10.0),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
