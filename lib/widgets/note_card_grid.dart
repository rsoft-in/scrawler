import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

import '../helpers/note_color.dart';

class NoteCardGrid extends StatefulWidget {
  final Notes? note;
  final Function onTap;
  final Function? onLongPress;
  const NoteCardGrid(
      {Key? key, this.note, required this.onTap, this.onLongPress})
      : super(key: key);

  @override
  _NoteCardGridState createState() => _NoteCardGridState();
}

class _NoteCardGridState extends State<NoteCardGrid> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      child: Card(
        color: NoteColor.getColor(widget.note!.noteColor, darkModeOn),
        child: InkWell(
          borderRadius: BorderRadius.circular(15.0),
          onTap: () => widget.onTap(),
          onLongPress: () => widget.onLongPress!(),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: widget.note!.noteTitle.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.note!.noteTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.note!.noteText,
                      maxLines: 6,
                      overflow: TextOverflow.fade,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                // NOTE WITH CHECK BOX
                // Visibility(
                //   visible: widget.note.noteList.contains('{'),
                //   child: Expanded(
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: NotesListViewExt(
                //           noteListItems: _noteList, noteColor: widget.note.noteColor),
                //     ),
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        widget.note!.noteLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black54, fontSize: 12.0),
                      )),
                      Text(
                        Utility.formatDateTime(widget.note!.noteDate),
                        style: TextStyle(color: Colors.black54, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
