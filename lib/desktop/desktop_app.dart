import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/desktop/pages/desktop_note_edit.dart';
import 'package:scrawler/desktop/pages/desktop_note_view.dart';
import 'package:scrawler/desktop/pages/settings.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/helpers/dbhelper.dart';
import 'package:scrawler/models/notes.dart';
import 'package:scrawler/widgets/rs_alert_dialog.dart';
import 'package:uuid/uuid.dart';

class DesktopApp extends StatefulWidget {
  const DesktopApp({super.key});

  @override
  State<DesktopApp> createState() => _DesktopAppState();
}

class _DesktopAppState extends State<DesktopApp> with TickerProviderStateMixin {
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

  showSettings() {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return const Dialog(
          child: SettingsPage(),
        );
      },
    );
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
            width: 250,
            child: Padding(
              padding: kPaddingMedium,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    onPressed: () => setState(() {
                      Notes newNote = Notes.empty();
                      newNote.noteId = const Uuid().v1();
                      selectedNote = newNote;
                      isNewNote = true;
                      editorMode = true;
                    }),
                    child: const Row(
                      children: [
                        Icon(Symbols.add),
                        kHSpace,
                        Text('Add Note'),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 0.2,
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
                    onTap: () => showSettings(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kBorderRadius)),
                  ),
                ],
              ),
            ),
          ),
          selectedNote != null
              ? Expanded(
                  child: editorMode
                      ? Card(
                          elevation: 5,
                          child: DesktopNoteEdit(
                            note: selectedNote!,
                            onSave: (note, isNew) {
                              saveNote(note, isNew);
                            },
                            isNewNote: isNewNote,
                          ),
                        )
                      : Card(
                          elevation: 5,
                          semanticContainer: false,
                          child: DesktopNoteView(
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
