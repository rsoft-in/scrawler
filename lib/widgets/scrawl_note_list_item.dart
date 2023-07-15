import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/note_color.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/notes.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

// ignore: must_be_immutable
class NoteListItemWidget extends StatefulWidget {
  Notes note;
  int selectedIndex;
  bool isSelected = false;
  VoidCallback? onTap;
  NoteListItemWidget(
      {Key? key,
      required this.note,
      required this.selectedIndex,
      required this.isSelected,
      this.onTap})
      : super(key: key);

  @override
  State<NoteListItemWidget> createState() => _NoteListItemWidgetState();
}

class _NoteListItemWidgetState extends State<NoteListItemWidget> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: widget.onTap,
        child: Container(
          padding: kGlobalCardPadding * 2,
          decoration: BoxDecoration(
            color: darkModeOn ? kDarkPrimary : kLightPrimary,
            border: widget.isSelected
                ? Border.all(
                    color: darkModeOn ? kDarkStroke : kLightStroke, width: 2)
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
                    '${(widget.note.noteLabel).split(',')[0]} ${widget.note.noteLabel.contains(',') ? '...' : ''}',
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
