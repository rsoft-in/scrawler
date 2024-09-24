import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/helpers/dbhelper.dart';
import 'package:scrawler/markdown_toolbar.dart';
import 'package:scrawler/models/notes.dart';
import 'package:uuid/uuid.dart';

class DesktopNoteEdit extends StatefulWidget {
  final Notes note;
  final Function(Notes, bool) onSave;
  final bool isNewNote;
  const DesktopNoteEdit(
      {super.key,
      required this.note,
      required this.onSave,
      this.isNewNote = false});

  @override
  State<DesktopNoteEdit> createState() => _DesktopNoteEditState();
}

class _DesktopNoteEditState extends State<DesktopNoteEdit> {
  TextEditingController titleController = TextEditingController();
  TextEditingController editorController = TextEditingController();
  UndoHistoryController undoController = UndoHistoryController();
  DBHelper dbHelper = DBHelper.instance;

  void saveNote() async {
    if (titleController.text.isEmpty) {
      titleController.text = 'Untitled';
    }
    if (editorController.text.isEmpty) {
      return;
    }
    Notes note = Notes.empty();
    if (widget.isNewNote) {
      var noteId = const Uuid().v1();
      note = Notes(noteId, DateTime.now().toString(), titleController.text,
          editorController.text, '', false, 0, '', false);
    } else {
      note = Notes(
          widget.note.noteId,
          DateTime.now().toString(),
          titleController.text,
          editorController.text,
          widget.note.noteLabel,
          widget.note.noteArchived,
          widget.note.noteColor,
          widget.note.noteImage,
          widget.note.noteFavorite);
    }
    widget.onSave(note, widget.isNewNote);
  }

  @override
  void initState() {
    super.initState();
    editorController.text = widget.note.noteText;
    titleController.text = widget.note.noteTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  autofocus: true,
                  controller: titleController,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter Title',
                    isCollapsed: true,
                    filled: false,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => saveNote(),
                icon: const Icon(Symbols.check),
              )
            ],
          ),
          const Divider(
            height: 2,
            thickness: 0.2,
          ),
          MarkdownToolbar(
            controller: editorController,
            undoController: undoController,
            onChange: () {},
          ),
          const Divider(
            height: 2,
            thickness: 0.2,
          ),
          Expanded(
            child: TextFormField(
              controller: editorController,
              maxLines: null,
              expands: true,
              style: const TextStyle(fontSize: 14.0),
              decoration: const InputDecoration(
                isCollapsed: true,
                filled: false,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
