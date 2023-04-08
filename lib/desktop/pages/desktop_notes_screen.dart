import 'dart:convert';

import 'package:bnotes/common/adaptive.dart';
import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/globals.dart' as globals;
import 'package:bnotes/common/language.dart';
import 'package:bnotes/common/string_values.dart';
import 'package:bnotes/common/utility.dart';
import 'package:bnotes/models/menu_item.dart';
import 'package:bnotes/models/notes.dart';
import 'package:bnotes/providers/notes_api_provider.dart';
import 'package:bnotes/widgets/scrawl_alert_dialog.dart';
import 'package:bnotes/widgets/scrawl_empty.dart';
import 'package:bnotes/widgets/scrawl_note_date_widget.dart';
import 'package:bnotes/widgets/scrawl_note_list_item.dart';
import 'package:bnotes/widgets/scrawl_snackbar.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DesktopNotesScreen extends StatefulWidget {
  const DesktopNotesScreen({Key? key}) : super(key: key);

  @override
  State<DesktopNotesScreen> createState() => _DesktopNotesScreenState();
}

class _DesktopNotesScreenState extends State<DesktopNotesScreen> {
  List<Notes> notesList = [];
  NoteSort currentSort = NoteSort.title;
  bool isNewNote = false;
  final int _pageNr = 0;
  bool isBusy = false;
  FocusNode focusNode = FocusNode();
  int wordCount = 0;
  bool isDesktop = false;
  int selectedIndex = 0;
  bool isSelected = false;
  bool darkModeOn = false;
  Offset _tapPosition = Offset.zero;
  List<MenuItem> contextMenuItems = [
    MenuItem('edit', Language.get('edit'), ''),
    MenuItem('delete', Language.get('delete'), ''),
    MenuItem('color', Language.get('color'), ''),
    MenuItem('tags', Language.get('tag'), '')
  ];

  TextEditingController noteTitleController = TextEditingController();
  TextEditingController noteTextController = TextEditingController();
  String currentNoteId = "";

  void getNotes() async {
    Map<String, String> post = {
      'postdata': jsonEncode({
        'api_key': globals.apiKey,
        'uid': globals.user!.userId,
        'qry': '',
        'sort': 'note_title',
        'page_no': _pageNr,
        'offset': 30
      })
    };
    setState(() {
      isBusy = true;
    });
    NotesApiProvider.fecthNotes(post).then((value) {
      if (value.error.isEmpty) {
        notesList = value.notes;
        isBusy = false;
        setState(() {});
        sortList(currentSort);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value.error),
          duration: const Duration(seconds: 2),
        ));
      }
    });
  }

  void sortList(NoteSort sort) {
    switch (sort) {
      case NoteSort.title:
        notesList
            .sort((Notes a, Notes b) => a.noteTitle.compareTo(b.noteTitle));
        break;
      case NoteSort.titleDesc:
        notesList
            .sort((Notes a, Notes b) => a.noteTitle.compareTo(b.noteTitle));
        notesList = notesList.reversed.toList();
        break;
      case NoteSort.oldest:
        notesList.sort((Notes a, Notes b) => a.noteDate.compareTo(b.noteDate));
        break;
      case NoteSort.newest:
        notesList.sort((Notes a, Notes b) => a.noteDate.compareTo(b.noteDate));
        notesList = notesList.reversed.toList();
        break;
      default:
        break;
    }
    currentSort = sort;
    setState(() {});
  }

  void saveNotes() async {
    var uuid = const Uuid();
    var newId = uuid.v1();
    if (isNewNote) {
      notesList.add(Notes(newId, Utility.getDateString(),
          noteTitleController.text, noteTextController.text, '', false, 0, ''));
    } else {
      int editIndex =
          notesList.indexWhere((element) => element.noteId == currentNoteId);
      notesList[editIndex].noteTitle = noteTitleController.text;
      notesList[editIndex].noteText = noteTextController.text;
    }
    setState(() {});
    sortList(currentSort);
    Map<String, String> post = {
      'postdata': jsonEncode({
        'new': isNewNote,
        'api_key': globals.apiKey,
        'note_id': isNewNote ? newId : currentNoteId,
        'note_user_id': globals.user!.userId,
        'note_date': Utility.getDateString(),
        'note_title': noteTitleController.text,
        'note_text': noteTextController.text,
        'note_label': '',
        'note_archived': 0,
        'note_color': 0,
        'note_image': '',
        'note_audio_file': ''
      })
    };
    NotesApiProvider.updateNotes(post).then((value) {
      if (value['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
            ScrawlSnackBar.show(context, Language.get('changes_saved')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value['error']),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void deleteNotes(String noteId) async {
    notesList.removeWhere((element) => element.noteId == noteId);
    if (selectedIndex > 0) {
      selectedIndex--;
    } else {
      selectedIndex = 0;
      isSelected = false;
    }
    setState(() {});
    Map<String, String> post = {
      'postdata': jsonEncode({
        'api_key': globals.apiKey,
        'note_id': noteId,
      })
    };
    NotesApiProvider.deleteNotes(post).then((value) {
      if (value['status']) {
        selectedIndex = 0;
        isSelected = false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value['error']),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    var brightness = MediaQuery.of(context).platformBrightness;
    darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (globals.themeMode == ThemeMode.system &&
            brightness == Brightness.dark));
    return Row(
      children: [
        SizedBox(
          width: 350,
          child: Scaffold(
            appBar: AppBar(title: Text(Language.get('notes')), actions: [
              PopupMenuButton<NoteSort>(
                itemBuilder: (_) => <PopupMenuItem<NoteSort>>[
                  const PopupMenuItem<NoteSort>(
                    value: NoteSort.title,
                    child: Text('A-Z'),
                  ),
                  const PopupMenuItem<NoteSort>(
                    value: NoteSort.titleDesc,
                    child: Text('Z-A'),
                  ),
                  PopupMenuItem<NoteSort>(
                    value: NoteSort.newest,
                    child: Text(Language.get('latest')),
                  ),
                  PopupMenuItem<NoteSort>(
                    value: NoteSort.oldest,
                    child: Text(Language.get('oldest')),
                  ),
                ],
                onSelected: (value) => sortList(value),
                icon: const Icon(BootstrapIcons.sort_up),
                tooltip: Language.get('sort'),
              ),
            ]),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: kLabels['search'],
                            prefixIcon: const Icon(
                              BootstrapIcons.search,
                              // size: 16,
                            ),
                          ),
                        ),
                      ),
                      kHSpace,
                      FloatingActionButton.small(
                        onPressed: () {
                          assignFields(Notes.empty());
                          showEditDialog(context);
                        },
                        child: const Icon(BootstrapIcons.plus),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isBusy
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : (notesList.isNotEmpty
                          ? ListView.builder(
                              padding: kGlobalOuterPadding,
                              itemCount: notesList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onSecondaryTapDown: (details) =>
                                      _getTapPosition(details),
                                  onSecondaryTap: () {
                                    selectedIndex = index;
                                    setState(() {});
                                    _showContextMenu(context, notesList[index]);
                                  },
                                  child: NoteListItemWidget(
                                      note: notesList[index],
                                      selectedIndex: selectedIndex,
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                          isSelected = true;
                                        });
                                      },
                                      isSelected:
                                          index == selectedIndex && isSelected),
                                );
                              },
                            )
                          : Center(
                              child: Text(Language.get('no_notes')),
                            )),
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(
          width: 0.5,
        ),
        Expanded(
          child: Scaffold(
            appBar: isSelected && notesList[selectedIndex].noteTitle.isNotEmpty
                ? AppBar(
                    scrolledUnderElevation: 0,
                    title: Text(notesList[selectedIndex].noteTitle),
                  )
                : null,
            body: Visibility(
              visible: isSelected,
              replacement: EmptyWidget(
                  text: Language.get('select_note'),
                  width: MediaQuery.of(context).size.width * 0.5 * 0.8,
                  asset: 'images/undraw_playful_cat.svg'),
              child: SingleChildScrollView(
                child: Padding(
                  padding: kGlobalOuterPadding * 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NoteDateWidget(
                        text: notesList.isEmpty
                            ? ''
                            : Utility.formatDateTime(
                                notesList[selectedIndex].noteDate),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 60),
                        child: SelectableText(
                          notesList.isEmpty
                              ? ''
                              : notesList[selectedIndex].noteText,
                          style: const TextStyle(
                            fontSize: 14.0,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: Visibility(
              visible: isSelected,
              replacement: Container(),
              child: Card(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 6),
                      child: Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                assignFields(notesList[selectedIndex]);
                                showEditDialog(context);
                              },
                              child: const Icon(
                                BootstrapIcons.pencil,
                                size: 18,
                              )),
                          TextButton(
                              onPressed: () {},
                              child: const Icon(
                                BootstrapIcons.palette2,
                                size: 18,
                              )),
                          TextButton(
                              onPressed: () {},
                              child: const Icon(
                                BootstrapIcons.tags,
                                size: 18,
                              )),
                          TextButton(
                              onPressed: () => confirmDelete(
                                  context, notesList[selectedIndex].noteId),
                              child: const Icon(
                                BootstrapIcons.trash3,
                                size: 18,
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void assignFields(Notes note) {
    setState(() {
      isNewNote = note.noteId.isEmpty;
      currentNoteId = note.noteId;
      noteTitleController.text = note.noteTitle;
      noteTextController.text = note.noteText;
    });
  }

  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }

  void _showContextMenu(BuildContext context, Notes note) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(_tapPosition.dx + 140, _tapPosition.dy, 30, 30),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height),
        ),
        items: List.generate(contextMenuItems.length, (index) {
          return PopupMenuItem(
            height: 35,
            value: contextMenuItems[index].value,
            child: Row(
              children: [
                Expanded(child: Text(contextMenuItems[index].caption)),
                Text(
                  contextMenuItems[index].hint,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          );
        }));
    switch (result) {
      case 'edit':
        assignFields(note);
        if (context.mounted) {
          showEditDialog(context);
        }
        break;
      case 'delete':
        deleteNotes(note.noteId);
        break;
      default:
        break;
    }
  }

  void showEditDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 74),
              child: Container(
                padding: kGlobalOuterPadding,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: noteTitleController,
                        style: const TextStyle(fontSize: 20.0),
                        decoration: InputDecoration.collapsed(
                          hintText: Language.get('enter_title'),
                        ),
                      ),
                      kVSpace,
                      Text(
                        '1 ${Language.get('min_ago')}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      kVSpace,
                      Row(
                        children: [
                          const Icon(
                            BootstrapIcons.tag,
                            size: 16,
                          ),
                          const VerticalDivider(color: Colors.black),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(BootstrapIcons.plus),
                          ),
                        ],
                      ),
                      kVSpace,
                      Expanded(
                        child: TextField(
                          controller: noteTextController,
                          decoration: InputDecoration.collapsed(
                            hintText: Language.get('type_something'),
                          ),
                          expands: true,
                          maxLines: null,
                        ),
                      ),
                      kVSpace,
                      Row(
                        children: [
                          const Icon(
                            BootstrapIcons.palette,
                            size: 16,
                          ),
                          const Spacer(),
                          FilledButton.tonal(
                            onPressed: () {
                              if (noteTextController.text.isNotEmpty) {
                                saveNotes();
                              }
                              Navigator.pop(context);
                            },
                            child: Text(Language.get('save')),
                          ),
                          kHSpace,
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(Language.get('cancel')),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void confirmDelete(BuildContext context, String noteId) {
    showDialog(
        context: context,
        builder: (context) {
          return ScrawlConfirmDialog(
            onAcceptPressed: () {
              deleteNotes(noteId);
              Navigator.pop(context);
            },
            content: Language.get('confirm_delete'),
          );
        });
  }
}

enum NoteSort { title, titleDesc, newest, oldest }
