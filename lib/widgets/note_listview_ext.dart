import 'package:bnotes/models/note_list_model.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class NotesListViewExt extends StatefulWidget {
  final List<NoteListItem> noteListItems;
  final int noteColor;

  const NotesListViewExt(
      {Key? key, required this.noteListItems, required this.noteColor})
      : super(key: key);

  @override
  _NotesListViewExtState createState() => _NotesListViewExtState();
}

class _NotesListViewExtState extends State<NotesListViewExt> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.noteListItems.length,
        itemBuilder: (context, pos) {
          return Container(
            child: Row(
              children: [
                widget.noteListItems[pos].checked == 'true'
                    ? Icon(
                        Icons.check_box,
                        color: darkModeOn && widget.noteColor == 0
                            ? Colors.white
                            : Colors.black,
                      )
                    : Icon(
                        Icons.check_box_outline_blank,
                        color: darkModeOn && widget.noteColor == 0
                            ? Colors.white
                            : Colors.black,
                      ),
                Expanded(
                    child: Text(
                  widget.noteListItems[pos].value,
                  style: TextStyle(
                    color: darkModeOn && widget.noteColor == 0
                        ? Colors.white
                        : Colors.black,
                  ),
                )),
              ],
            ),
          );
        });
  }
}
