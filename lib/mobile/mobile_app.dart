import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/mobile/dbhelper.dart';
import 'package:scrawler/mobile/pages/mobile_note_edit.dart';
import 'package:scrawler/models/notes.dart';
import 'package:scrawler/widgets/scrawl_color_picker.dart';

class MobileApp extends StatefulWidget {
  const MobileApp({super.key});

  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  List<Notes> notes = [];
  final dbHelper = DBHelper();
  SearchController searchController = SearchController();

  Future<void> getNotes() async {
    notes = await dbHelper.getNotesAll('', 'note_date DESC');
    setState(() {});
  }

  Future<void> saveColor(String noteId, int noteColor) async {
    final res = await dbHelper.updateNoteColor(noteId, noteColor);
    if (res) {
      setState(() {
        final index = notes.indexWhere((n) => n.noteId == noteId);
        notes[index].noteColor = noteColor;
      });
    } else {
      print('Unable to save note color!');
    }
  }

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(kAppName),
      // ),
      body: notes.isEmpty
          ? const Center(
              child: Text('No Notes'),
            )
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SearchAnchor(
                      builder:
                          (BuildContext context, SearchController controller) {
                        return SearchBar(
                          controller: controller,
                          autoFocus: false,
                          elevation: const WidgetStatePropertyAll(0),
                          padding: const WidgetStatePropertyAll<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 16.0)),
                          onTap: () {
                            controller.openView();
                          },
                          onChanged: (_) {
                            controller.openView();
                          },
                          leading: const Icon(Icons.search),
                          hintText: 'Search note',
                          trailing: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Symbols.account_circle))
                          ],
                        );
                      },
                      suggestionsBuilder:
                          (BuildContext context, SearchController controller) {
                        final List<Notes> suggestions = notes
                            .where((n) => n.noteTitle
                                .toLowerCase()
                                .contains(controller.text.toLowerCase()))
                            .toList();

                        return List<ListTile>.generate(
                          suggestions.length,
                          (int index) {
                            return ListTile(
                              title: Text(suggestions[index].noteTitle),
                              onTap: () {
                                setState(() {
                                  controller
                                      .closeView(suggestions[index].noteTitle);
                                  controller.clear();
                                });
                                openNote(suggestions[index], false, true);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(notes[index].noteTitle),
                          onTap: () => openNote(notes[index], false, true),
                          onLongPress: () => onNoteLongPressed(notes[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  void onNoteLongPressed(Notes note) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: kGlobalOuterPadding,
            child: ListView(
              children: [
                const ListTile(
                  leading: Icon(Symbols.folder_copy),
                  title: Text('Move to Folder'),
                ),
                const ListTile(
                  leading: Icon(Symbols.favorite),
                  title: Text('Add to Favorites'),
                ),
                ListTile(
                  leading: const Icon(Symbols.palette),
                  title: const Text('Change Color'),
                  onTap: () => changeColor(note),
                ),
                const ListTile(
                  leading: Icon(Symbols.archive),
                  title: Text('Archive'),
                ),
                const ListTile(
                  leading: Icon(Symbols.delete),
                  title: Text('Delete'),
                ),
              ],
            ),
          );
        });
  }

  void changeColor(Notes note) async {
    final colorCode = await showDialog(
        context: context,
        builder: (context) {
          return const ScrawlColorPicker();
        });
    if (colorCode != null) {
      if (mounted) {
        Navigator.pop(context);
      }
      saveColor(note.noteId, colorCode);
    }
  }
}
