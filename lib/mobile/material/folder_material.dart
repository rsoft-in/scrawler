import 'package:bnotes/mobile/material/note_material.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../helpers/constants.dart';
import '../../helpers/dbhelper.dart';
import '../../helpers/utility.dart';
import '../../models/notes.dart';
import '../../widgets/scrawl_alert_dialog.dart';
import '../../widgets/scrawl_color_dot.dart';
import '../../widgets/scrawl_color_picker.dart';
import '../../widgets/scrawl_empty.dart';
import 'label_select_material.dart';

class FolderPageMaterial extends StatefulWidget {
  final String folderName;
  const FolderPageMaterial({super.key, required this.folderName});

  @override
  State<FolderPageMaterial> createState() => _FolderPageMaterialState();
}

class _FolderPageMaterialState extends State<FolderPageMaterial> {
  DBHelper dbHelper = DBHelper.instance;

  Future<List<Notes>> fetchNotesByFolder() async {
    return await dbHelper.getNotesByFolder(widget.folderName, 'note_title');
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Symbols.folder),
            kHSpace,
            Expanded(child: Text(widget.folderName)),
          ],
        ),
      ),
      body: FutureBuilder<List<Notes>>(
        future: fetchNotesByFolder(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: EmptyWidget(
                      text: 'Start writing something today...',
                      width: MediaQuery.of(context).size.width * 0.5,
                      asset: 'images/nothing_to_do.svg'),
                );
              } else {
                List<Notes> notes = snapshot.data!;
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Symbols.note),
                    title: Text(notes[index].noteTitle),
                    subtitle: Text(
                      notes[index].noteText,
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
              }
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNote(Notes.empty()),
        child: const Icon(Symbols.add),
      ),
    );
  }

  void openNote(Notes note) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotePageMaterial(note, widget.folderName)));

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
}
