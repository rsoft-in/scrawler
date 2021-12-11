import 'dart:convert';

import 'package:bnotes/constants.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/note_list_model.dart';
import 'package:bnotes/pages/app.dart';
import 'package:bnotes/pages/edit_note_page.dart';
import 'package:bnotes/pages/note_reader_page.dart';
import 'package:bnotes/widgets/note_listview_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/helpers/note_color.dart';
import 'package:bnotes/helpers/storage.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/pages/labels_page.dart';
import 'package:bnotes/widgets/color_palette.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:universal_platform/universal_platform.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title})
      : super(key: HomePage.staticGlobalKey);
  final String title;

  static final GlobalKey<_HomePageState> staticGlobalKey =
      new GlobalKey<_HomePageState>();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences sharedPreferences;
  bool isAppLogged = false;
  String userFullname = "";
  String userId = "";
  String userEmail = "";
  Storage storage = new Storage();
  String backupPath = "";
  late ViewType _viewType;
  ViewType viewType = ViewType.Tile;
  ScrollController scrollController = new ScrollController();
  List<Notes> notesList = [];
  bool isLoading = false;
  bool hasData = false;

  bool isAndroid = UniversalPlatform.isAndroid;
  bool isIOS = UniversalPlatform.isIOS;
  bool isWeb = UniversalPlatform.isWeb;
  bool isDesktop = UniversalPlatform.isDesktop;

  final dbHelper = DatabaseHelper.instance;
  var uuid = Uuid();
  TextEditingController _noteTitleController = new TextEditingController();
  TextEditingController _noteTextController = new TextEditingController();
  String currentEditingNoteId = "";
  TextEditingController _searchController = new TextEditingController();

  int selectedPageColor = 1;

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isAppLogged = sharedPreferences.getBool("is_logged") ?? false;
      bool isTile = sharedPreferences.getBool("is_tile") ?? false;
      _viewType = isTile ? ViewType.Tile : ViewType.Grid;
      viewType = isTile ? ViewType.Tile : ViewType.Grid;
    });
  }

  loadNotes() async {
    setState(() {
      isLoading = true;
    });

    if (isAndroid || isIOS) {
      await dbHelper.getNotesAll(_searchController.text).then((value) {
        setState(() {
          print(value.length);
          isLoading = false;
          hasData = value.length > 0;
          notesList = value;
        });
      });
    }
  }

  void toggleView(ViewType viewType) {
    setState(() {
      _viewType = viewType;
      sharedPreferences.setBool("is_tile", _viewType == ViewType.Tile);
    });
  }

  void _updateColor(String noteId, int noteColor) async {
    print(noteColor);
    await dbHelper.updateNoteColor(noteId, noteColor).then((value) {
      loadNotes();
      setState(() {
        selectedPageColor = noteColor;
      });
    });
  }

  void _archiveNote(int archive) async {
    await dbHelper.archiveNote(currentEditingNoteId, archive).then((value) {
      loadNotes();
    });
  }

  void _deleteNote() async {
    await dbHelper.deleteNotes(currentEditingNoteId).then((value) {
      loadNotes();
    });
  }

  @override
  void initState() {
    getPref();
    loadNotes();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : (hasData
                      ? (_viewType == ViewType.Grid
                          ? StaggeredGridView.countBuilder(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 0,
                              physics: BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              itemCount: notesList.length,
                              staggeredTileBuilder: (index) {
                                return StaggeredTile.count(
                                    1, index.isOdd ? 0.9 : 1.02);
                              },
                              itemBuilder: (context, index) {
                                var note = notesList[index];
                                List<NoteListItem> _noteList = [];
                                if (note.noteList.contains('{')) {
                                  try {
                                    final parsed = json
                                        .decode(note.noteText)
                                        .cast<Map<String, dynamic>>();
                                    _noteList = parsed
                                        .map<NoteListItem>((json) =>
                                            NoteListItem.fromJson(json))
                                        .toList();
                                  } on Exception catch (e) {
                                    // TODO
                                  }
                                }
                                return Container(
                                  margin: EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Card(
                                    color: NoteColor.getColor(
                                        note.noteColor, darkModeOn),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(15.0),
                                      onTap: () {
                                        setState(() {
                                          selectedPageColor = note.noteColor;
                                        });
                                        _showNoteReader(context, note);
                                      },
                                      onLongPress: () {
                                        _showOptionsSheet(context, note);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Visibility(
                                              visible:
                                                  note.noteTitle.isNotEmpty,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  note.noteTitle,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: darkModeOn &&
                                                              note.noteColor ==
                                                                  0
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  note.noteText,
                                                  maxLines: 6,
                                                  overflow: TextOverflow.fade,
                                                  style: TextStyle(
                                                      color: darkModeOn &&
                                                              note.noteColor ==
                                                                  0
                                                          ? Colors.white60
                                                          : Colors.black38),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  note.noteList.contains('{'),
                                              child: Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: NotesListViewExt(
                                                      noteListItems: _noteList,
                                                      noteColor:
                                                          note.noteColor),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                    note.noteLabel,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: darkModeOn &&
                                                                note.noteColor ==
                                                                    0
                                                            ? Colors.white38
                                                            : Colors.black38,
                                                        fontSize: 12.0),
                                                  )),
                                                  Text(
                                                    Utility.formatDateTime(
                                                        note.noteDate),
                                                    style: TextStyle(
                                                        color: darkModeOn &&
                                                                note.noteColor ==
                                                                    0
                                                            ? Colors.white38
                                                            : Colors.black38,
                                                        fontSize: 12.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: notesList.length,
                              physics: BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              itemBuilder: (context, index) {
                                var note = notesList[index];
                                List<NoteListItem> _noteList = [];
                                if (note.noteList.contains('{')) {
                                  final parsed = json
                                      .decode(note.noteText)
                                      .cast<Map<String, dynamic>>();
                                  _noteList = parsed
                                      .map<NoteListItem>(
                                          (json) => NoteListItem.fromJson(json))
                                      .toList();
                                }
                                return Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Card(
                                    color: NoteColor.getColor(
                                        note.noteColor, darkModeOn),
                                    // margin: EdgeInsets.only(
                                    //     left: 5, right: 5, top: 10),
                                    // padding: EdgeInsets.all(8.0),
                                    // decoration: BoxDecoration(
                                    //     color: NoteColor.getColor(
                                    //         note.noteColor, darkModeOn),
                                    //     borderRadius: BorderRadius.circular(10.0),
                                    //     boxShadow: [
                                    //       BoxShadow(
                                    //           color: Colors.black26,
                                    //           blurRadius: 1.0,
                                    //           offset: new Offset(1, 1)),
                                    //     ]),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedPageColor = note.noteColor;
                                        });
                                        _showNoteReader(context, note);
                                      },
                                      onLongPress: () =>
                                          _showOptionsSheet(context, note),
                                      child: Padding(
                                        padding: kGlobalCardPadding,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Visibility(
                                              visible:
                                                  note.noteTitle.isNotEmpty,
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                  note.noteTitle,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: darkModeOn &&
                                                            note.noteColor == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                note.noteText,
                                                style: TextStyle(
                                                  color: darkModeOn &&
                                                          note.noteColor == 0
                                                      ? Colors.white60
                                                      : Colors.black38,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  note.noteList.contains('{'),
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Container(
                                                  height: 50,
                                                  child: NotesListViewExt(
                                                      noteListItems: _noteList,
                                                      noteColor:
                                                          note.noteColor),
                                                ),
                                              ),
                                            ),
                                            Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                padding: EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        note.noteLabel,
                                                        style: TextStyle(
                                                            color: darkModeOn &&
                                                                    note.noteColor ==
                                                                        0
                                                                ? Colors.white38
                                                                : Colors
                                                                    .black38,
                                                            fontSize: 12.0),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        Utility.formatDateTime(
                                                            note.noteDate),
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                            color: darkModeOn &&
                                                                    note.noteColor ==
                                                                        0
                                                                ? Colors.white38
                                                                : Colors
                                                                    .black38,
                                                            fontSize: 12.0),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ))
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.note_alt_outlined,
                                size: 120,
                              ),
                              Text(
                                'No notes',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 22),
                              ),
                            ],
                          ),
                        )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _noteTextController.text = '';
            _noteTitleController.text = '';
            currentEditingNoteId = "";
          });
          _showEdit(context, new Notes('', '', '', '', '', 0, 0, ''));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showOptionsSheet(BuildContext context, Notes _note) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                child: Container(
                  child: Padding(
                    padding: kGlobalOuterPadding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _noteTextController.text =
                                  Utility.stripTags(_note.noteText);
                              _noteTitleController.text = _note.noteTitle;
                              currentEditingNoteId = _note.noteId;
                            });
                            _showEdit(context, _note);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.edit_outlined),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Edit'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _showColorPalette(context, _note);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.palette_outlined),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Color Palette'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _assignLabel(_note);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.new_label_outlined),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Assign Labels'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _note.noteArchived == 0,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                currentEditingNoteId = _note.noteId;
                              });
                              _archiveNote(1);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.archive_outlined),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Archive'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _note.noteArchived == 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                currentEditingNoteId = _note.noteId;
                              });
                              _archiveNote(0);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.archive_rounded),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Unarchive'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() {
                              currentEditingNoteId = _note.noteId;
                            });
                            _confirmDelete();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.delete_outline_rounded),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.clear),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Cancel'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  void _showColorPalette(BuildContext context, Notes _note) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: kGlobalOuterPadding,
              child: Container(
                height: 100,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 12),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ColorPalette(
                        color: NoteColor.getColor(0, darkModeOn),
                        onTap: () {
                          _updateColor(_note.noteId, 0);
                          Navigator.pop(context);
                        },
                        isSelected: _note.noteColor == 0,
                      ),
                      ColorPalette(
                        color: NoteColor.getColor(1, darkModeOn),
                        onTap: () {
                          _updateColor(_note.noteId, 1);
                          Navigator.pop(context);
                        },
                        isSelected: _note.noteColor == 1,
                      ),
                      ColorPalette(
                        color: NoteColor.getColor(2, darkModeOn),
                        onTap: () {
                          _updateColor(_note.noteId, 2);
                          Navigator.pop(context);
                        },
                        isSelected: _note.noteColor == 2,
                      ),
                      ColorPalette(
                        color: NoteColor.getColor(3, darkModeOn),
                        onTap: () {
                          _updateColor(_note.noteId, 3);
                          Navigator.pop(context);
                        },
                        isSelected: _note.noteColor == 3,
                      ),
                      ColorPalette(
                        color: NoteColor.getColor(4, darkModeOn),
                        onTap: () {
                          _updateColor(_note.noteId, 4);
                          Navigator.pop(context);
                        },
                        isSelected: _note.noteColor == 4,
                      ),
                      ColorPalette(
                        color: NoteColor.getColor(5, darkModeOn),
                        onTap: () {
                          _updateColor(_note.noteId, 5);
                          Navigator.pop(context);
                        },
                        isSelected: _note.noteColor == 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showNoteReader(BuildContext context, Notes _note) async {
    bool res = await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new NoteReaderPage(
              note: _note,
            )));
    if (res) loadNotes();
  }

  void _confirmDelete() async {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (context) {
          return Container(
            child: Padding(
              padding: kGlobalOuterPadding,
              child: Container(
                height: 150,
                child: Padding(
                  padding: kGlobalOuterPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: kGlobalCardPadding,
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: kGlobalCardPadding,
                        child: Text('Are you sure you want to delete?'),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: kGlobalCardPadding,
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('No'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: kGlobalCardPadding,
                              child: ElevatedButton(
                                onPressed: () {
                                  _deleteNote();
                                  Navigator.pop(context, true);
                                },
                                child: Text('Yes'),
                              ),
                            ),
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

  void _assignLabel(Notes note) async {
    final res = await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new LabelsPage(
              noteid: note.noteId,
              notelabel: note.noteLabel,
            )));
    if (res is Notes) loadNotes();
  }

  void _showEdit(BuildContext context, Notes _note) async {
    final res = await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new EditNotePage(
              note: _note,
            )));
    if (res is Notes) loadNotes();
  }

  // Future<bool> _onBackPressed() async {
  //   if (!(_noteTitleController.text.isEmpty ||
  //       _noteTextController.text.isEmpty)) {
  //     _saveNote();
  //   }
  //   return true;
  // }

  String getDateString() {
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime dt = DateTime.now();
    return formatter.format(dt);
  }
}
