import 'package:flutter/material.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/helpers/note_color.dart';
import 'package:scrawler/helpers/utility.dart';
import 'package:scrawler/models/notes.dart';

// ignore: must_be_immutable
class NoteListItemWidget extends StatefulWidget {
  Notes note;
  int selectedIndex;
  bool isSelected = false;
  VoidCallback? onTap;
  VoidCallback? onLongPress;
  NoteListItemWidget(
      {super.key,
      required this.note,
      required this.selectedIndex,
      required this.isSelected,
      this.onTap,
      this.onLongPress});

  @override
  State<NoteListItemWidget> createState() => _NoteListItemWidgetState();
}

class _NoteListItemWidgetState extends State<NoteListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 10.0,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Container(
          padding: kGlobalCardPadding * 2,
          decoration: BoxDecoration(
            border: widget.isSelected
                ? Border.all(width: 2)
                : Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
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
                          fontSize: 14.0,
                        ),
                      ),
                      kVSpace,
                      Text(
                        Utility.formatDateTime(widget.note.noteDate),
                        style: const TextStyle(
                          fontSize: 10.0,
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
              kHSpace,
              Container(
                width: 5,
                height: 50,
                decoration: BoxDecoration(
                  color: NoteColor.getColor(widget.note.noteColor, false),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
