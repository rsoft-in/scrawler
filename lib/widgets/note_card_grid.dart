import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/utility.dart';
import 'package:bnotes/models/notes.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

import '../common/note_color.dart';

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
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(width: 1, color: kBorderColor)),
        color: NoteColor.getColor(widget.note!.noteColor, darkModeOn),
        child: InkWell(
          borderRadius: BorderRadius.circular(5.0),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 3),
                    child: Text(
                      widget.note!.noteTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 3),
                    child: Text(
                      widget.note!.noteText,
                      maxLines: 6,
                      overflow: TextOverflow.fade,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                  child: Text(
                    Utility.formatDateTime(widget.note!.noteDate),
                    style: TextStyle(color: Colors.black54, fontSize: 12.0),
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //           child: Text(
                //         widget.note!.noteLabel,
                //         maxLines: 1,
                //         overflow: TextOverflow.ellipsis,
                //         style: TextStyle(color: Colors.black54, fontSize: 12.0),
                //       )),
                //       Text(
                //         Utility.formatDateTime(widget.note!.noteDate),
                //         style: TextStyle(color: Colors.black54, fontSize: 12.0),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
