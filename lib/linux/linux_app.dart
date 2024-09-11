import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/helpers/dbhelper.dart';
import 'package:scrawler/linux/pages/linux_note_edit.dart';
import 'package:scrawler/linux/pages/linux_note_view.dart';
import 'package:scrawler/models/notes.dart';
import 'package:scrawler/widgets/rs_alert_dialog.dart';
import 'package:uuid/uuid.dart';

class LinuxApp extends StatefulWidget {
  const LinuxApp({super.key});

  @override
  State<LinuxApp> createState() => _LinuxAppState();
}

class _LinuxAppState extends State<LinuxApp> {
  bool editorMode = false;
  bool isNewNote = false;
  final dbHelper = DBHelper.instance;
  List<Notes> notes = [];
  Notes? selectedNote;

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
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 280,
            child: Padding(
              padding: kPaddingMedium,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ListTile(
                    leading: const Icon(Symbols.add),
                    title: const Text('Add Note'),
                    onTap: () => setState(() {
                      Notes newNote = Notes.empty();
                      newNote.noteId = const Uuid().v1();
                      selectedNote = newNote;
                      isNewNote = true;
                      editorMode = true;
                    }),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kBorderRadius)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Symbols.note),
                          title: Text(notes[index].noteTitle),
                          onTap: () => onNoteSelected(notes[index]),
                          selected: selectedNote?.noteId == notes[index].noteId,
                          selectedTileColor: kPrimaryColor.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Symbols.settings),
                    title: const Text('Settings'),
                    onTap: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kBorderRadius)),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(
            width: 2,
          ),
          selectedNote != null
              ? Expanded(
                  child: editorMode
                      ? LinuxNoteEdit(
                          note: selectedNote!,
                          onSave: (note, isNew) {
                            saveNote(note, isNew);
                          },
                          isNewNote: isNewNote,
                        )
                      : LinuxNoteView(
                          note: selectedNote!,
                          onEditClicked: () {
                            setState(() {
                              editorMode = true;
                              isNewNote = false;
                            });
                          },
                          onDeleteClicked: () {
                            Future.delayed(const Duration(microseconds: 500),
                                () {
                              if (mounted) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return RSAlertDialog(
                                        title: const Text('Confirm'),
                                        content: const Text(
                                            'Are you sure you want to Delete?'),
                                        acceptText: 'Yes',
                                        rejectText: 'No',
                                        onAcceptAction: () => deleteNote(),
                                      );
                                    });
                              }
                            });
                          },
                        ),
                )
              : const Expanded(
                  child: Center(
                    child: Text('Select a Note'),
                  ),
                ),
        ],
      ),
    );
  }
}
