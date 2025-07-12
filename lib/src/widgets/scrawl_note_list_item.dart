import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/helpers/note_color.dart';
import 'package:scrawler/src/helpers/utility.dart';
import 'package:scrawler/src/models/notes.dart';

// ignore: must_be_immutable
class NoteListItem extends StatefulWidget {
  Notes note;
  int selectedIndex;
  VoidCallback? onTap;
  VoidCallback? onLongPress;
  bool showOptionButton;
  VoidCallback? onOptionTap;
  NoteListItem(
      {super.key,
      required this.note,
      required this.selectedIndex,
      this.onTap,
      this.onLongPress,
      this.showOptionButton = false,
      this.onOptionTap});

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
        onLongPress: widget.showOptionButton ? null : widget.onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
              if (widget.showOptionButton)
                IconButton(
                  onPressed: widget.onOptionTap,
                  icon: Icon(Symbols.more_vert),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
