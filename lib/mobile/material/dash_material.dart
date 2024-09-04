import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/helpers/dbhelper.dart';
import 'package:scrawler/helpers/utility.dart';
import 'package:scrawler/mobile/material/backup_restore_material.dart';
import 'package:scrawler/mobile/material/folder_material.dart';
import 'package:scrawler/mobile/material/note_material.dart';
import 'package:scrawler/mobile/material/search_material.dart';
import 'package:scrawler/models/label.dart';
import 'package:scrawler/models/notes.dart';
import 'package:scrawler/widgets/scrawl_alert_dialog.dart';
import 'package:scrawler/widgets/scrawl_color_dot.dart';

import '../../widgets/scrawl_color_picker.dart';
import '../../widgets/scrawl_empty.dart';
import 'label_select_material.dart';

class DashMaterial extends StatefulWidget {
  const DashMaterial({super.key});

  @override
  State<DashMaterial> createState() => _DashMaterialState();
}

class _DashMaterialState extends State<DashMaterial> {
  DBHelper dbHelper = DBHelper.instance;
  final _fabKey = GlobalKey<ExpandableFabState>();

  Future<List<Notes>> fetchNotesFav() async {
    return await dbHelper.getNotesFavorite();
  }

  Future<List<Notes>> fetchNotes() async {
    List<Notes> unLabeled = await dbHelper.getNotesUnLabeled('note_title');
    List<Label> labels = await dbHelper.getLabelsAll();
    List<Notes> mapedNotes = labels
        .map((e) => Notes('', '', '', '', e.labelName, false, 0, '', false))
        .toList();
    List<Notes> unLabeledList = [];
    unLabeledList.addAll(mapedNotes);
    unLabeledList.addAll(unLabeled);
    return unLabeledList;
  }

  Future<void> deleteNote(Notes note) async {
    await dbHelper.deleteNotes(note.noteId);
    setState(() {});
  }

  Future<void> updateFavorite(Notes note) async {
    await dbHelper.updateNoteFavorite(note.noteId, !note.noteFavorite);
    setState(() {});
  }

  Future<void> updateLabel(Notes note, String noteLabel) async {
    await dbHelper.updateNoteLabel(note.noteId, noteLabel);
    setState(() {});
  }

  Future<void> updateColor(Notes note, int noteColor) async {
    await dbHelper.updateNoteColor(note.noteId, noteColor);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder<List<Notes>> favNotesBuilder = FutureBuilder<List<Notes>>(
      future: fetchNotesFav(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.data!.isNotEmpty) {
              List<Notes> notes = snapshot.data!;
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Symbols.note),
                  title: Text(notes[index].noteTitle),
                  subtitle: Text(
                    Utility.stripNoteOfMD(notes[index].noteText),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ScrawlColorDot(colorCode: notes[index].noteColor),
                      Text(Utility.readableDate(notes[index].noteDate)),
                    ],
                  ),
                  onTap: () => openNote(notes[index]),
                  onLongPress: () => optionsSheet(notes[index]),
                ),
              );
            } else {
              return Center(
                child: EmptyWidget(
                    text: 'Start writing something today...',
                    width: MediaQuery.of(context).size.width * 0.5,
                    asset: 'images/nothing_to_do.svg'),
              );
            }
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            return Container();
        }
      },
    );

    FutureBuilder<List<Notes>> allNotesBuilder = FutureBuilder<List<Notes>>(
      future: fetchNotes(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.data!.isNotEmpty) {
              List<Notes> notes = snapshot.data!;
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => ListTile(
                  leading: notes[index].noteTitle.isEmpty
                      ? const Icon(Symbols.folder)
                      : const Icon(Symbols.note),
                  title: Text(
                    notes[index].noteTitle.isEmpty
                        ? notes[index].noteLabel
                        : notes[index].noteTitle,
                    // style: TextStyle(
                    //   fontWeight: notes[index].noteTitle.isEmpty
                    //       ? FontWeight.bold
                    //       : FontWeight.normal,
                    // ),
                  ),
                  subtitle: notes[index].noteTitle.isEmpty
                      ? null
                      : Text(
                          Utility.stripNoteOfMD(notes[index].noteText),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ScrawlColorDot(colorCode: notes[index].noteColor),
                      Text(Utility.readableDate(notes[index].noteDate)),
                    ],
                  ),
                  onTap: notes[index].noteTitle.isEmpty
                      ? () => openFolder(notes[index])
                      : () => openNote(notes[index]),
                  onLongPress: notes[index].noteTitle.isEmpty
                      ? null
                      : () => optionsSheet(notes[index]),
                ),
              );
            } else {
              return Center(
                child: EmptyWidget(
                    text: 'Start writing something today...',
                    width: MediaQuery.of(context).size.width * 0.5,
                    asset: 'images/nothing_to_do.svg'),
              );
            }
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            return Container();
        }
      },
    );

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            kAppName,
            style: TextStyle(fontFamily: 'Inter'),
          ),
          actions: [
            IconButton(
              onPressed: () => openSearch(),
              icon: const Icon(Symbols.search),
            ),
            IconButton(
              onPressed: () => openSettings(),
              icon: const Icon(Symbols.person),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('Favorites'),
              ),
              Tab(
                child: Text('All Notes'),
              )
            ],
          ),
        ),
        body: TabBarView(children: [
          favNotesBuilder,
          allNotesBuilder,
        ]),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
            key: _fabKey,
            openButtonBuilder: RotateFloatingActionButtonBuilder(
                child: const Icon(Symbols.add)),
            closeButtonBuilder: RotateFloatingActionButtonBuilder(
                child: const Icon(Symbols.close),
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white),
            distance: 80,
            type: ExpandableFabType.up,
            children: [
              FloatingActionButton.extended(
                heroTag: 'note',
                onPressed: () {
                  final state = _fabKey.currentState;
                  if (state != null) {
                    state.toggle();
                  }
                  openNote(Notes.empty());
                },
                icon: const Icon(Symbols.note_add),
                label: const Text('Note'),
              ),
              FloatingActionButton.extended(
                heroTag: 'folder',
                onPressed: () {
                  final state = _fabKey.currentState;
                  if (state != null) {
                    state.toggle();
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LabelSelectMaterial(
                                standalone: true,
                              )));
                },
                label: const Text('Folder'),
                icon: const Icon(Symbols.folder),
              ),
            ]),
      ),
    );
  }

  void openSearch() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SearchPageMaterial()));
  }

  void openFolder(Notes note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FolderPageMaterial(folderName: note.noteLabel),
      ),
    );
    setState(() {});
  }

  void openNote(Notes note) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NotePageMaterial(note, null)));

    setState(() {});
  }

  void optionsSheet(Notes note) {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (context) => Padding(
              padding: kGlobalOuterPadding,
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Symbols.edit),
                    title: const Text('Edit'),
                    onTap: () {
                      Navigator.pop(context);
                      openNote(note);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Symbols.delete),
                    title: const Text('Delete'),
                    onTap: () {
                      deleteConfirmation(note);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Symbols.favorite),
                    title: Text(note.noteFavorite
                        ? 'Remove from Favorotes'
                        : 'Add to Favorites'),
                    onTap: () {
                      Navigator.pop(context);
                      updateFavorite(note);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Symbols.folder_open),
                    title: const Text('Move to'),
                    onTap: () => assignLabel(note),
                  ),
                  ListTile(
                    leading: const Icon(Symbols.color_lens),
                    title: const Text('Assign Color'),
                    onTap: () => assignColor(note),
                  ),
                ],
              ),
            ));
  }

  void deleteConfirmation(Notes note) {
    showDialog(
        context: context,
        builder: (context) {
          return ScrawlConfirmDialog(
            onAcceptPressed: () {
              deleteNote(note);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            content: 'Are you sure you want to delete?',
          );
        });
  }

  Future<void> assignLabel(Notes note) async {
    final labelName = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const LabelSelectMaterial()));
    if (labelName != null) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      updateLabel(note, labelName);
    }
  }

  Future<void> assignColor(Notes note) async {
    final colorCode = await showDialog(
        context: context,
        builder: (context) {
          return const ScrawlColorPicker();
        });
    if (colorCode != null) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      updateColor(note, colorCode);
    }
  }

  void openSettings() {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (context) {
          return Padding(
            padding: kGlobalOuterPadding,
            child: ListView(
              children: [
                const ListTile(
                  leading: CircleAvatar(
                    child: Icon(Symbols.person),
                  ),
                  title: Text('Anonymous'),
                  subtitle: Text('Free Account'),
                ),
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Symbols.home_storage),
                  ),
                  title: const Text('Backup & Restore'),
                  subtitle: const Text('Locally backup notes'),
                  onTap: () => backupRestore(),
                ),
              ],
            ),
          );
        });
  }

  Future<void> backupRestore() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BackupRestorePageMaterial(),
      ),
    );
    setState(() {});
  }
}
