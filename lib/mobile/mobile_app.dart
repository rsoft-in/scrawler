import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/mobile/dbhelper.dart';
import 'package:scrawler/mobile/pages/mobile_note_edit.dart';
import 'package:scrawler/models/notes.dart';

class MobileApp extends StatefulWidget {
  const MobileApp({super.key});

  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  List<Notes> notes = [];
  final dbHelper = DBHelper();

  Future<void> getNotes() async {
    notes = await dbHelper.getNotesAll('', 'note_title');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppName),
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text('No Notes'),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notes[index].noteTitle),
                  onTap: () => openNote(notes[index], false, true),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNote(Notes.empty(), true, false),
        child: const Icon(Symbols.add),
      ),
    );
  }

  void openNote(Notes note, bool isNew, bool readMode) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileNoteEdit(
          note: note,
          isNewNote: isNew,
          readMode: readMode,
        ),
      ),
    );
    if (result) {
      getNotes();
    }
  }
}
