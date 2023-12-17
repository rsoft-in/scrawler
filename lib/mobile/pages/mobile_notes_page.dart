import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/dbhelper.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:bnotes/mobile/pages/mobile_labels_page.dart';
import 'package:bnotes/mobile/pages/mobile_note_editor.dart';
import 'package:bnotes/models/notes.dart';
import 'package:bnotes/widgets/scrawl_color_picker.dart';
import 'package:bnotes/widgets/scrawl_empty.dart';
import 'package:bnotes/widgets/scrawl_note_list_item.dart';
import 'package:bnotes/widgets/scrawl_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yaru_icons/yaru_icons.dart';

import '../../models/menu_item.dart';
import '../../models/sort_items.dart';
import '../../widgets/scrawl_snackbar.dart';

class MobileNotesPage extends StatefulWidget {
  const MobileNotesPage({Key? key}) : super(key: key);

  @override
  State<MobileNotesPage> createState() => _MobileNotesPageState();
}

class _MobileNotesPageState extends State<MobileNotesPage> {
  final dbHelper = DBHelper.instance;
  bool isLoading = true;
  bool showSearchBar = true;
  List<Notes> notes = [];
  List<Notes> notesUnfiltered = [];
  List<MenuItem> contextMenuItems = [
    MenuItem('edit', 'Edit', '', YaruIcons.pen),
    MenuItem('delete', 'Delete', '', YaruIcons.trash),
    MenuItem('color', 'Colors', '', YaruIcons.colors),
    MenuItem('tags', 'Tags', '', YaruIcons.tag)
  ];
  List<SortItem> sortItems = [
    SortItem(NoteSort.newest, 'Latest'),
    SortItem(NoteSort.oldest, 'Oldest'),
    SortItem(NoteSort.title, 'A-Z'),
    SortItem(NoteSort.titleDesc, 'Z-A')
  ];
  NoteSort currentSort = NoteSort.newest;

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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : (notes.isEmpty
              ? const EmptyWidget(
                  text: 'Create Note',
                  width: 250,
                  asset: 'images/undraw_playful_cat.svg')
              : Column(
                  children: [
                    Visibility(
                      visible: showSearchBar,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: ScrawlSearch(
                                controller: searchController,
                                onSearch: () => onSearch(),
                                onClearSearch: () {
                                  searchController.clear();
                                  onSearch();
                                },
                              ),
                            ),
                            kHSpace,
                            MenuAnchor(
                              builder: (context, controller, child) {
                                return InkWell(
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadius),
                                  onTap: () {
                                    if (controller.isOpen) {
                                      controller.close();
                                    } else {
                                      controller.open();
                                    }
                                  },
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
                                      borderRadius:
                                          BorderRadius.circular(kBorderRadius),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: const Icon(Icons.sort),
                                  ),
                                );
                              },
                              menuChildren:
                                  List.generate(sortItems.length, (index) {
                                return MenuItemButton(
                                  onPressed: () =>
                                      sortList(sortItems[index].sortBy),
                                  leadingIcon:
                                      (sortItems[index].sortBy == currentSort)
                                          ? const Icon(
                                              Icons.check_outlined,
                                              size: 16.0,
                                            )
                                          : const Icon(
                                              Icons.check_outlined,
                                              size: 16.0,
                                              color: Colors.transparent,
                                            ),
                                  child: Text(
                                    sortItems[index].caption,
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: NotificationListener<UserScrollNotification>(
                        onNotification: (notification) {
                          if (notification.direction ==
                              ScrollDirection.reverse) {
                            if (showSearchBar) {
                              setState(() {
                                showSearchBar = false;
                              });
                            }
                          } else if (notification.direction ==
                              ScrollDirection.forward) {
                            if (!showSearchBar) {
                              setState(() {
                                showSearchBar = true;
                              });
                            }
                          }
                          return true;
                        },
                        child: ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            return NoteListItemWidget(
                              isSelected: false,
                              note: notes[index],
                              selectedIndex: 0,
                              onTap: () => openReader(notes[index]),
                              onLongPress: () =>
                                  showOptions(context, notes[index]),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => editNote(Notes.empty()),
        child: const Icon(YaruIcons.plus),
      ),
    );
  }

  void onSearch() {
    var phrase = searchController.text;
    setState(() {
      notes = notesUnfiltered
          .where((element) =>
              element.noteTitle.toLowerCase().contains(phrase.toLowerCase()) ||
              element.noteText.toLowerCase().contains(phrase.toLowerCase()))
          .toList();
    });
  }

  void sortList(NoteSort sort) {
    switch (sort) {
      case NoteSort.title:
        notes.sort((Notes a, Notes b) => a.noteTitle.compareTo(b.noteTitle));
        break;
      case NoteSort.titleDesc:
        notes.sort((Notes a, Notes b) => b.noteTitle.compareTo(a.noteTitle));
        break;
      case NoteSort.newest:
        notes.sort((Notes a, Notes b) => b.noteDate.compareTo(a.noteDate));
        break;
      case NoteSort.oldest:
        notes.sort((Notes a, Notes b) => a.noteDate.compareTo(b.noteDate));
        break;
      default:
        break;
    }
    currentSort = sort;
    setState(() {});
  }

  Future<void> loadNotes() async {
    dbHelper.getNotesAll('', 'note_date desc').then((value) {
      setState(() {
        notesUnfiltered = value;
        notes = notesUnfiltered;
        isLoading = false;
      });
    });
  }

  void openReader(Notes note) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MobileNoteEditor(
                  note: note,
                  editMode: false,
                )));
    if (result is bool) {
      if (result) {
        loadNotes();
      }
      return;
    }

    if ((result ?? '').contains('delete')) {
      deleteNote(note);
    }
  }

  void editNote(Notes note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MobileNoteEditor(
                note: note,
                editMode: true,
              )),
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
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: kGlobalOuterPadding,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: contextMenuItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () =>
                        onContextSelected(contextMenuItems[index].value, note),
                    leading: Icon(contextMenuItems[index].icon),
                    title: Text(contextMenuItems[index].caption),
                  );
                }),
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
          return const ScrawlColorPicker();
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
