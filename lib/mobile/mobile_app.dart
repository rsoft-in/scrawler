import 'package:flutter/material.dart';
import 'package:scrawler/helpers/dbhelper.dart';
import 'package:scrawler/models/notes.dart';

class MobileApp extends StatefulWidget {
  const MobileApp({super.key});

  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  bool editorMode = false;
  bool showSidebar = true;
  bool isNewNote = false;
  final dbHelper = DBHelper.instance;
  List<Notes> notes = [];
  Notes? selectedNote;
  bool darkModeOn = false;
  bool isLargeDevice = false;

  Future<void> getNotes() async {
    notes = await dbHelper.getNotesAll('', 'note_title');
    setState(() {});
  }

  void onNoteSelected(Notes note) {
    setState(() {
      selectedNote = note;
      editorMode = false;
      isNewNote = false;
    });
  }

  Future<void> saveNote(Notes note, bool isNew) async {
    if (isNew) {
      await dbHelper.insertNotes(note);
    } else {
      await dbHelper.updateNotes(note);
    }
    getNotes();
    setState(() {
      selectedNote = note;
      editorMode = false;
      isNewNote = false;
    });
  }

  Future<void> deleteNote() async {
    await dbHelper.deleteNotes(selectedNote!.noteId);
    setState(() {
      selectedNote = null;
    });
    getNotes();
  }

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
