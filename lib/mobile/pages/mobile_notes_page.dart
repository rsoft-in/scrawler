import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/dbhelper.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:bnotes/helpers/language.dart';
import 'package:bnotes/mobile/pages/mobile_labels_page.dart';
import 'package:bnotes/mobile/pages/mobile_note_editor.dart';
import 'package:bnotes/mobile/pages/mobile_note_reader.dart';
import 'package:bnotes/models/notes.dart';
import 'package:bnotes/widgets/scrawl_empty.dart';
import 'package:bnotes/widgets/scrawl_note_list_item.dart';
import 'package:bnotes/widgets/scrawl_search.dart';
import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';

import '../../helpers/note_color.dart';
import '../../models/menu_item.dart';
import '../../widgets/color_palette_button.dart';
import '../../widgets/scrawl_snackbar.dart';

class MobileNotesPage extends StatefulWidget {
  const MobileNotesPage({Key? key}) : super(key: key);

  @override
  State<MobileNotesPage> createState() => _MobileNotesPageState();
}

class _MobileNotesPageState extends State<MobileNotesPage> {
  final dbHelper = DBHelper.instance;
  List<Notes> notes = [];
  List<MenuItem> contextMenuItems = [
    MenuItem('edit', Language.get('edit'), '', YaruIcons.pen),
    MenuItem('delete', Language.get('delete'), '', YaruIcons.trash),
    MenuItem('color', Language.get('color'), '', YaruIcons.colors),
    MenuItem('tags', Language.get('tag'), '', YaruIcons.tag)
  ];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    loadNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Scaffold(
      body: notes.isEmpty
          ? EmptyWidget(
              text: Language.get('select_note'),
              width: MediaQuery.of(context).size.width * 0.8,
              asset: 'images/undraw_playful_cat.svg')
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Visibility(
                            visible: index == 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22.0, vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ScrawlSearch(
                                      controller: searchController,
                                      onSearch: () {},
                                      onClearSearch: () {},
                                    ),
                                  ),
                                  kHSpace,
                                  InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: darkModeOn
                                            ? kDarkPrimary
                                            : kLightPrimary,
                                        border: Border.all(
                                            color: darkModeOn
                                                ? kDarkStroke
                                                : kLightStroke,
                                            width: 2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      child: const Icon(Icons.sort),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          NoteListItemWidget(
                            isSelected: false,
                            note: notes[index],
                            selectedIndex: 0,
                            onTap: () => openReader(notes[index]),
                            onLongPress: () =>
                                showOptions(context, notes[index]),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => editNote(Notes.empty()),
        child: const Icon(YaruIcons.plus),
      ),
    );
  }

  Future<void> loadNotes() async {
    dbHelper.getNotesAll('', 'note_date desc').then((value) {
      setState(() {
        notes = value;
      });
    });
  }

  void openReader(Notes note) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => MobileNoteReader(note: note)));
    if (result is bool) {
      return;
    }
    if (result.contains('edit')) {
      editNote(note);
    }
  }

  void editNote(Notes note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MobileNoteEditor(note: note)),
    );
    if (result) {
      loadNotes();
    }
  }

  void deleteNote(Notes note) async {
    final result = await dbHelper.deleteNotes(note.noteId);
    if (!result) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(ScrawlSnackBar.show(context, 'Failed to delete!'));
      }
    } else {
      int idx = notes.indexWhere((el) => el.noteId == note.noteId);
      if (idx >= 0) {
        setState(() {
          notes.removeAt(idx);
        });
      }
    }
  }

  void updateNoteColor(Notes note, int colorCode) async {
    final result = await dbHelper.updateNoteColor(note.noteId, colorCode);
    if (!result) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(ScrawlSnackBar.show(context, 'Failed to update!'));
      }
    }
  }

  void updateNoteLabel(Notes note, String label) async {
    final result = await dbHelper.updateNoteLabel(note.noteId, label);
    if (!result) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(ScrawlSnackBar.show(context, 'Failed to update!'));
      }
    }
  }

  void showOptions(BuildContext context, Notes note) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: kGlobalOuterPadding,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: contextMenuItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => onContextSelected(
                          contextMenuItems[index].value, note),
                      leading: Icon(contextMenuItems[index].icon),
                      title: Text(contextMenuItems[index].caption),
                    );
                  }),
            ),
          );
        });
  }

  void onContextSelected(String action, Notes note) {
    Navigator.pop(context);
    switch (action) {
      case 'edit':
        editNote(note);
        break;
      case 'delete':
        confirmDelete(note);
        break;
      case 'color':
        pickColor(note);
        break;
      case 'tags':
        selectTag(note);
        break;
      default:
    }
  }

  void confirmDelete(Notes note) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              FilledButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  deleteNote(note);
                },
              ),
              OutlinedButton(
                child: const Text('No'),
                onPressed: () => Navigator.pop(context),
              )
            ],
            title: const Text('Confirm'),
            content: const Text('Are you sure you want to delete?'),
          );
        });
  }

  void pickColor(Notes note) async {
    final colorCode = await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 160),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Select Color'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ColorPaletteButton(
                            onTap: () => Navigator.pop(context, 1),
                            color: NoteColor.getColor(1, false),
                            isSelected: false),
                        ColorPaletteButton(
                            onTap: () => Navigator.pop(context, 2),
                            color: NoteColor.getColor(2, false),
                            isSelected: false),
                        ColorPaletteButton(
                            onTap: () => Navigator.pop(context, 3),
                            color: NoteColor.getColor(3, false),
                            isSelected: false),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ColorPaletteButton(
                            onTap: () => Navigator.pop(context, 4),
                            color: NoteColor.getColor(4, false),
                            isSelected: false),
                        ColorPaletteButton(
                            onTap: () => Navigator.pop(context, 5),
                            color: NoteColor.getColor(5, false),
                            isSelected: false),
                        ColorPaletteButton(
                            onTap: () => Navigator.pop(context, 6),
                            color: NoteColor.getColor(6, false),
                            isSelected: false),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context, 0),
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Icon(Icons.block),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    if (colorCode != null) {
      int index = notes.indexWhere((el) => el.noteId == note.noteId);
      notes[index].noteColor = colorCode;
      setState(() {});
      updateNoteColor(note, colorCode);
    }
  }

  void selectTag(Notes note) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MobileLabelsPage(preselect: note.noteLabel)));
    if (result != null) {
      int index = notes.indexWhere((el) => el.noteId == note.noteId);
      notes[index].noteLabel = result;
      setState(() {});
      updateNoteLabel(note, result);
    }
  }
}
