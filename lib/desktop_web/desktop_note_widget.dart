import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/notes.dart';
import 'package:bnotes/widgets/scrawl_empty.dart';
import 'package:flutter/material.dart';

class DesktopNoteWidget extends StatefulWidget {
  final Notes note;
  const DesktopNoteWidget(this.note, {Key? key}) : super(key: key);

  @override
  State<DesktopNoteWidget> createState() => _DesktopNoteWidgetState();
}

class _DesktopNoteWidgetState extends State<DesktopNoteWidget> {
  ScreenSize _screenSize = ScreenSize.large;

  @override
  Widget build(BuildContext context) {
    _screenSize = getScreenSize(context);

    return Padding(
      padding: kPaddingLarge,
      child: widget.note.noteId.isEmpty
          ? EmptyWidget(
              text: 'Select a Note to preview',
              width: MediaQuery.of(context).size.width * 0.4,
              asset: 'images/undraw_playful_cat.svg')
          : Text(widget.note.noteText),
    );
  }
}
