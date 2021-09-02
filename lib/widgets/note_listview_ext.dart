import 'package:bnotes/models/note_list_model.dart';
import 'package:flutter/material.dart';

class NotesListViewExt extends StatefulWidget {
  final List<NoteListItem> noteListItems;

  const NotesListViewExt({Key? key, required this.noteListItems})
      : super(key: key);

  @override
  _NotesListViewExtState createState() => _NotesListViewExtState();
}

class _NotesListViewExtState extends State<NotesListViewExt> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.noteListItems.length,
        itemBuilder: (context, pos) {
          return Container(
            child: Row(
              children: [
                widget.noteListItems[pos].checked == 'true'
                    ? Icon(Icons.check_box)
                    : Icon(Icons.check_box_outline_blank),
                Expanded(child: Text(widget.noteListItems[pos].value)),
              ],
            ),
          );
        });
  }
}
