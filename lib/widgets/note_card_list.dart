import 'package:bnotes/common/constants.dart';
import 'package:bnotes/helpers/note_color.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class NoteCardList extends StatefulWidget {
  final Notes? note;
  final Function onTap;
  final Function? onLongPress;
  const NoteCardList(
      {Key? key, this.note, required this.onTap, this.onLongPress})
      : super(key: key);

  @override
  _NoteCardListState createState() => _NoteCardListState();
}

class _NoteCardListState extends State<NoteCardList> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Card(
        color: NoteColor.getColor(widget.note!.noteColor, darkModeOn),
        child: InkWell(
          onTap: () => widget.onTap(),
          onLongPress: () => widget.onLongPress!(),
          child: Padding(
            padding: kGlobalCardPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: widget.note!.noteTitle.isNotEmpty,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      widget.note!.noteTitle,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    widget.note!.noteText,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Visibility(
                //   visible:
                //       widget.note.noteList.contains('{'),
                //   child: Padding(
                //     padding: EdgeInsets.all(5.0),
                //     child: Container(
                //       height: 50,
                //       child: NotesListViewExt(
                //           noteListItems:
                //               _noteList,
                //           noteColor:
                //               note.noteColor),
                //     ),
                //   ),
                // ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.note!.noteLabel.replaceAll(",", ", "),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          Utility.formatDateTime(
                            widget.note!.noteDate,
                          ),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12.0,
                          ),
                        ),
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
