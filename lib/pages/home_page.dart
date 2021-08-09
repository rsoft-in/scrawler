import 'dart:async';
import 'dart:convert';

import 'package:bnotes/constants.dart';
import 'package:bnotes/pages/backup_restore_page.dart';
import 'package:bnotes/pages/login_page.dart';
import 'package:bnotes/pages/note_reader_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/helpers/note_color.dart';
import 'package:bnotes/helpers/storage.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/pages/labels_page.dart';
import 'package:bnotes/widgets/color_palette.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

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
  bool isTileView = false;
  ScrollController scrollController = new ScrollController();
  List<Notes> notesList = [];
  bool isLoading = false;
  bool hasData = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
      isTileView = sharedPreferences.getBool("is_tile") ?? false;
    });
  }

  loadNotes() async {
    setState(() {
      isLoading = true;
    });

    await dbHelper.getNotesAll(_searchController.text).then((value) {
      setState(() {
        print(value.length);
        isLoading = false;
        hasData = value.length > 0;
        notesList = value;
      });
    });
  }

  void _saveNote() async {
    if (currentEditingNoteId.isEmpty) {
      await dbHelper
          .insertNotes(new Notes(uuid.v1(), DateTime.now().toString(),
              _noteTitleController.text, _noteTextController.text, '', 0, 0))
          .then((value) {
        loadNotes();
      });
    } else {
      await dbHelper
          .updateNotes(new Notes(
              currentEditingNoteId,
              DateTime.now().toString(),
              _noteTitleController.text,
              _noteTextController.text,
              '',
              0,
              0))
          .then((value) {
        loadNotes();
      });
    }
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

  void _onSearch() {
    loadNotes();
  }

  void _onClearSearch() {
    setState(() {
      _searchController.text = "";
      loadNotes();
    });
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/bnotes-transparent.png',
              height: 50,
            ),
            Container(
                alignment: Alignment.center,
                child: Text(
                  kAppName,
                  style: TextStyle(fontFamily: 'Raleway'),
                )),
          ],
        ),
      ),
      body: Container(
        padding: kGlobalOuterPadding,
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
                      ? (isTileView
                          // ? GridView.count(
                          //     mainAxisSpacing: 3.0,
                          //     crossAxisCount: 2,
                          //     shrinkWrap: true,
                          //     children:
                          //         List.generate(notesList.length, (index) {
                          //       var note = notesList[index];
                          //       return Card(
                          //         color: NoteColor.getColor(note.noteColor),
                          //         elevation: 2,
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(10.0),
                          //         ),
                          //         child: InkWell(
                          //           borderRadius: BorderRadius.circular(15.0),
                          //           onTap: () {
                          //             setState(() {
                          //               selectedPageColor = note.noteColor;
                          //             });
                          //             _showNoteReader(context, note);
                          //           },
                          //           onLongPress: () {
                          //             _showOptionsSheet(context, note);
                          //           },
                          //           child: Container(
                          //             padding: const EdgeInsets.all(8.0),
                          //             child: Column(
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //               children: [
                          //                 Padding(
                          //                   padding: const EdgeInsets.all(8.0),
                          //                   child: Text(
                          //                     note.noteTitle,
                          //                     maxLines: 1,
                          //                     overflow: TextOverflow.ellipsis,
                          //                     style: TextStyle(
                          //                         fontSize: 20.0,
                          //                         color: Colors.black),
                          //                   ),
                          //                 ),
                          //                 Expanded(
                          //                   child: Padding(
                          //                     padding:
                          //                         const EdgeInsets.all(8.0),
                          //                     child: Text(
                          //                       note.noteText,
                          //                       maxLines: 6,
                          //                       overflow: TextOverflow.ellipsis,
                          //                       style: TextStyle(
                          //                           color: Colors.black38),
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 Container(
                          //                   padding: EdgeInsets.all(8.0),
                          //                   child: Row(
                          //                     mainAxisAlignment:
                          //                         MainAxisAlignment
                          //                             .spaceBetween,
                          //                     children: [
                          //                       Expanded(
                          //                           child: Text(
                          //                         note.noteLabel,
                          //                         maxLines: 1,
                          //                         overflow:
                          //                             TextOverflow.ellipsis,
                          //                         style: TextStyle(
                          //                             color: Colors.black45,
                          //                             fontSize: 12.0),
                          //                       )),
                          //                       Text(
                          //                         formatDateTime(note.noteDate),
                          //                         style: TextStyle(
                          //                             color: Colors.black45,
                          //                             fontSize: 12.0),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       );
                          //     }),
                          //   )
                          ? StaggeredGridView.countBuilder(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              shrinkWrap: true,
                              itemCount: notesList.length,
                              staggeredTileBuilder: (index) {
                                return StaggeredTile.count(
                                    1, index.isEven ? 1.2 : 0.8);
                              },
                              itemBuilder: (context, index) {
                                var note = notesList[index];
                                return Card(
                                  color: NoteColor.getColor(note.noteColor, darkModeOn),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
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
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              note.noteTitle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: darkModeOn && note.noteColor==0 ? Colors.white : Colors.black),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                note.noteText,
                                                maxLines: 6,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color:  darkModeOn && note.noteColor==0 ? Colors.white : Colors.black),
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
                                                      color: darkModeOn && note.noteColor==0 ? Colors.white : Colors.black,
                                                      fontSize: 12.0),
                                                )),
                                                Text(
                                                  formatDateTime(note.noteDate),
                                                  style: TextStyle(
                                                      color: darkModeOn && note.noteColor==0 ? Colors.white : Colors.black,
                                                      fontSize: 12.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: notesList.length,
                              itemBuilder: (context, index) {
                                var note = notesList[index];
                                return Container(
                                  margin: EdgeInsets.all(5.0),
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: NoteColor.getColor(note.noteColor, darkModeOn),
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 1.0,
                                            offset: new Offset(1, 1)),
                                      ]),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPageColor = note.noteColor;
                                      });
                                      _showNoteReader(context, note);
                                    },
                                    onLongPress: () =>
                                        _showOptionsSheet(context, note),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            note.noteTitle,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            note.noteText,
                                            style: TextStyle(
                                                color: Colors.black38),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.all(5.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    note.noteLabel,
                                                    style: TextStyle(
                                                        color: Colors.black38,
                                                        fontSize: 12.0),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    formatDateTime(
                                                        note.noteDate),
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        color: Colors.black38,
                                                        fontSize: 12.0),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ))
                      : Center(
                          child: Text('No notes'),
                        )),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _noteTextController.text = '';
            _noteTitleController.text = '';
            currentEditingNoteId = "";
          });
          _showEdit(context);
        },
        child: Icon(CupertinoIcons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          children: <Widget>[
            // IconButton(
            //   icon: Icon(MyFlutterApp.menu),
            //   onPressed: () {
            //     _showMenuModalSheet(context);
            //   },
            // ),
            IconButton(
                onPressed: () => _showMenuOptions(),
                icon: Icon(Icons.menu_rounded)),
            // IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
            Visibility(
              visible: isTileView,
              child: IconButton(
                icon: Icon(Icons.view_agenda_outlined),
                onPressed: () {
                  setState(() {
                    sharedPreferences.setBool("is_tile", false);
                    isTileView = false;
                  });
                },
              ),
            ),
            Visibility(
              visible: !isTileView,
              child: IconButton(
                icon: Icon(Icons.grid_view_rounded),
                onPressed: () {
                  setState(() {
                    sharedPreferences.setBool("is_tile", true);
                    isTileView = true;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMenuOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (context) {
        return Container(
          // alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: kGlobalOuterPadding,
                  child: Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: kGlobalCardPadding,
                          child: (isAppLogged
                              ? InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blue[100],
                                      foregroundColor: Colors.blue,
                                      child: Icon(Icons.person),
                                    ),
                                    title: Text(sharedPreferences
                                            .getString('nc_userdisplayname') ??
                                        ''),
                                    subtitle: Text(sharedPreferences
                                            .getString('nc_useremail') ??
                                        ''),
                                  ),
                                )
                              : InkWell(
                                  borderRadius: BorderRadius.circular(15.0),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final result = await Navigator.of(context)
                                        .push(CupertinoPageRoute(
                                            builder: (context) => LoginPage()));
                                    if (result == true)
                                      setState(() {
                                        isAppLogged = true;
                                      });
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blue[100],
                                      foregroundColor: Colors.blue,
                                      child: Icon(Icons.person),
                                    ),
                                    title: Text('Nextcloud Login'),
                                    subtitle: Text('Sync Notes to cloud'),
                                  ),
                                )),
                        ),
                        Padding(
                          padding: kGlobalCardPadding,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15.0),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => LabelsPage(
                                        noteid: '',
                                        notelabel: '',
                                      )));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.purple[100],
                                foregroundColor: Colors.purple,
                                child: Icon(Icons.label_outlined),
                              ),
                              title: Text('Labels'),
                              subtitle: Text('Create labels'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: kGlobalCardPadding,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15.0),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => LabelsPage(
                                        noteid: '',
                                        notelabel: '',
                                      )));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.red[100],
                                foregroundColor: Colors.red,
                                child: Icon(Icons.archive_outlined),
                              ),
                              title: Text('Archive'),
                              subtitle: Text('See your archived notes'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: kGlobalCardPadding,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15.0),
                            onTap: () async {
                              Navigator.pop(context);
                              final res = await Navigator.of(context).push(
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          BackupRestorePage()));
                              if (res == "yes") {
                                loadNotes();
                              }
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal[100],
                                foregroundColor: Colors.teal,
                                child: Icon(Icons.backup_outlined),
                              ),
                              title: Text('Backup & Restore'),
                              subtitle: Text('Bring back the dead'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOptionsSheet(BuildContext context, Notes _note) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Padding(
                    padding: kGlobalOuterPadding,
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ColorPalette(
                                  color: Color(0xFFA8EAD5),
                                  onTap: () => _updateColor(_note.noteId, 0),
                                  isSelected: _note.noteColor == 0,
                                ),
                                ColorPalette(
                                  color: Colors.red.shade300,
                                  onTap: () => _updateColor(_note.noteId, 1),
                                  isSelected: _note.noteColor == 1,
                                ),
                                ColorPalette(
                                  color: Colors.pink.shade300,
                                  onTap: () => _updateColor(_note.noteId, 2),
                                  isSelected: _note.noteColor == 2,
                                ),
                                ColorPalette(
                                  color: Colors.yellow.shade300,
                                  onTap: () => _updateColor(_note.noteId, 3),
                                  isSelected: _note.noteColor == 3,
                                ),
                                ColorPalette(
                                  color: Colors.blue.shade300,
                                  onTap: () => _updateColor(_note.noteId, 4),
                                  isSelected: _note.noteColor == 4,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                _noteTextController.text = _note.noteText;
                                _noteTitleController.text = _note.noteTitle;
                                currentEditingNoteId = _note.noteId;
                              });
                              _showEdit(context);
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
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                currentEditingNoteId = _note.noteId;
                              });
                              _deleteNote();
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
                ),
              );
            },
          );
        });
  }

  void _showColorPalette(BuildContext context, Notes _note) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        builder: (context) {
          return Container(
            child: Padding(
              padding: kGlobalOuterPadding,
              child: Container(
                height: 100,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ColorPalette(
                          color: Color(0xFFA8EAD5),
                          onTap: () {
                            _updateColor(_note.noteId, 0);
                            Navigator.pop(context);
                          },
                          isSelected: _note.noteColor == 0,
                        ),
                        ColorPalette(
                          color: Colors.red.shade300,
                          onTap: () {
                            _updateColor(_note.noteId, 1);
                            Navigator.pop(context);
                          },
                          isSelected: _note.noteColor == 1,
                        ),
                        ColorPalette(
                          color: Colors.pink.shade300,
                          onTap: () {
                            _updateColor(_note.noteId, 2);
                            Navigator.pop(context);
                          },
                          isSelected: _note.noteColor == 2,
                        ),
                        ColorPalette(
                          color: Colors.yellow.shade300,
                          onTap: () {
                            _updateColor(_note.noteId, 3);
                            Navigator.pop(context);
                          },
                          isSelected: _note.noteColor == 3,
                        ),
                        ColorPalette(
                          color: Colors.blue.shade300,
                          onTap: () {
                            _updateColor(_note.noteId, 4);
                            Navigator.pop(context);
                          },
                          isSelected: _note.noteColor == 4,
                        ),
                      ],
                    ),
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

    // Navigator.of(context).push(new CupertinoPageRoute<Null>(
    //   maintainState: false,
    //   builder: (context) {
    //     return Scaffold(
    //       backgroundColor: NoteColor.getColor(selectedPageColor),
    //       appBar: AppBar(
    //         // title: Text(
    //         //   _note.noteTitle,
    //         //   style: TextStyle(color: Colors.black),
    //         // ),
    //         actions: [
    //           IconButton(
    //             onPressed: () {
    //               // Navigator.of(context).pop();
    //               setState(() {
    //                 _noteTextController.text = _note.noteText;
    //                 _noteTitleController.text = _note.noteTitle;
    //                 currentEditingNoteId = _note.noteId;
    //               });
    //               _showEdit(context);
    //             },
    //             icon: Icon(Icons.edit_outlined),
    //           ),
    //           IconButton(
    //             onPressed: () {
    //               _showColorPalette(context, _note);
    //             },
    //             icon: Icon(Icons.palette_outlined),
    //           ),
    //           IconButton(
    //             onPressed: () {
    //               _assignLabel(_note);
    //             },
    //             icon: Icon(Icons.new_label_outlined),
    //           ),
    //           IconButton(
    //             onPressed: () {},
    //             icon: Icon(Icons.archive_outlined),
    //           ),
    //           IconButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //               setState(() {
    //                 currentEditingNoteId = _note.noteId;
    //               });
    //               _deleteNote();
    //             },
    //             icon: Icon(Icons.delete_outline_rounded),
    //           ),
    //         ],
    //         elevation: 0,
    //         iconTheme: IconThemeData(color: Colors.black),
    //         backgroundColor: NoteColor.getColor(selectedPageColor),
    //       ),
    //       body: Column(
    //         children: [
    //           Container(
    //             padding: kGlobalOuterPadding,
    //             margin: EdgeInsets.only(left: 8),
    //             alignment: Alignment.centerLeft,
    //             child: Text(
    //               _note.noteTitle,
    //               style: TextStyle(
    //                   color: Colors.black,
    //                   fontSize: 22,
    //                   fontWeight: FontWeight.w700),
    //             ),
    //           ),
    //           // Divider(),
    //           Expanded(
    //             child: Markdown(
    //               styleSheet:
    //                   MarkdownStyleSheet.fromTheme(Theme.of(context).copyWith(
    //                 textTheme: TextTheme(
    //                   bodyText1: TextStyle(color: Colors.black, fontSize: 14),
    //                   bodyText2: TextStyle(color: Colors.black, fontSize: 14),
    //                   headline1: TextStyle(color: Colors.black),
    //                   headline2: TextStyle(color: Colors.black),
    //                   headline3: TextStyle(color: Colors.black),
    //                   headline4: TextStyle(color: Colors.black),
    //                   headline5: TextStyle(color: Colors.black),
    //                   headline6: TextStyle(color: Colors.black),
    //                 ),
    //               )),
    //               data: _note.noteText,
    //               controller: scrollController,
    //             ),
    //           ),
    //         ],
    //       ),
    //       bottomNavigationBar: BottomAppBar(
    //         color: NoteColor.getColor(selectedPageColor),
    //         child: Padding(
    //           padding: const EdgeInsets.all(10.0),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 child: Text(
    //                   _note.noteLabel.replaceAll(",", ", "),
    //                   maxLines: 1,
    //                   overflow: TextOverflow.ellipsis,
    //                   style: TextStyle(color: Colors.black),
    //                 ),
    //               ),
    //               Text(formatDateTime(_note.noteDate),
    //                   style: TextStyle(color: Colors.black)),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // ));
  }

  void _assignLabel(Notes note) async {
    bool res = await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new LabelsPage(
              noteid: note.noteId,
              notelabel: note.noteLabel,
            )));
    if (res) loadNotes();
  }

  void _showEdit(BuildContext context) {
    Navigator.of(context).push(new CupertinoPageRoute(
      builder: (context) {
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: new Scaffold(
            appBar: AppBar(
              title: Text('Edit'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: kGlobalOuterPadding,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: kGlobalOuterPadding,
                      child: Container(
                        child: TextField(
                          controller: _noteTitleController,
                          decoration: InputDecoration(
                              hintText: 'Title',
                              hintStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        maxLines: 20,
                        textCapitalization: TextCapitalization.sentences,
                        controller: _noteTextController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Write something here...',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // bottomNavigationBar: BottomAppBar(
            //   child: Container(
            //     padding: EdgeInsets.only(
            //         bottom: MediaQuery.of(context).viewInsets.bottom),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         IconButton(
            //           icon: Icon(CupertinoIcons.checkmark_square),
            //           onPressed: () {},
            //           tooltip: 'Insert Checkbox',
            //         ),
            //         IconButton(
            //           icon: Icon(CupertinoIcons.photo_fill_on_rectangle_fill),
            //           onPressed: () {},
            //           tooltip: 'Insert Pictures',
            //         ),
            //         IconButton(
            //           icon: Icon(CupertinoIcons.list_bullet),
            //           onPressed: () {},
            //           tooltip: 'Insert List',
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ),
        );
      },
    ));
  }

  Future<bool> _onBackPressed() async {
    if (!(_noteTitleController.text.isEmpty ||
        _noteTextController.text.isEmpty)) {
      _saveNote();
    }
    return true;
  }

  // void _showMenuModalSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         height: 150,
  //         padding: EdgeInsets.all(10.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             InkWell(
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 _showAppLock(context);
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(
  //                     horizontal: 10.0, vertical: 15.0),
  //                 child: Row(
  //                   children: <Widget>[
  //                     Icon(MyFlutterApp.archive),
  //                     Container(
  //                       margin: EdgeInsets.only(right: 10.0),
  //                     ),
  //                     Text('Archived'),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             InkWell(
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 _showBackupRestore(context);
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(
  //                     horizontal: 10.0, vertical: 15.0),
  //                 child: Row(
  //                   children: <Widget>[
  //                     Icon(MyFlutterApp.backup),
  //                     Container(
  //                       margin: EdgeInsets.only(right: 10.0),
  //                     ),
  //                     Text('Backup & Restore'),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _showBackupRestore(BuildContext context) {
  //   _getBackupPath();
  //   Navigator.of(context).push(new CupertinoPageRoute<Null>(
  //     builder: (context) {
  //       return new Scaffold(
  //         appBar: AppBar(
  //           title: Text('Backup & Restore'),
  //         ),
  //         body: SingleChildScrollView(
  //           child: Container(
  //             padding: EdgeInsets.all(20.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: <Widget>[
  //                 Container(
  //                   padding: EdgeInsets.all(20.0),
  //                   child: Text('Path: $backupPath'),
  //                 ),
  //                 Container(
  //                   padding: EdgeInsets.all(20.0),
  //                   child: OutlineButton.icon(
  //                     onPressed: () {
  //                       _makeBackup();
  //                       Navigator.pop(context);
  //                     },
  //                     highlightedBorderColor: Theme.of(context).accentColor,
  //                     highlightColor: Colors.white10,
  //                     icon: Icon(MyFlutterApp.backup),
  //                     label: Text('Backup'),
  //                   ),
  //                 ),
  //                 Container(
  //                   padding: EdgeInsets.all(20.0),
  //                   child: OutlineButton.icon(
  //                     onPressed: () {
  //                       _restore();
  //                       Navigator.pop(context);
  //                     },
  //                     highlightedBorderColor: Theme.of(context).accentColor,
  //                     highlightColor: Colors.white10,
  //                     icon: Icon(MyFlutterApp.restore),
  //                     label: Text('Restore'),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   ));
  // }

  void _showAppLock(BuildContext context) {
    Navigator.of(context).push(new CupertinoPageRoute<Null>(builder: (context) {
      return new Scaffold(
        appBar: AppBar(
          title: Text('Manage Pin'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Old Pin',
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'New Pin',
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Pin',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }));
  }

  String getDateString() {
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime dt = DateTime.now();
    return formatter.format(dt);
  }

  String formatDateTime(String dateTime) {
    var formatter = new DateFormat('MMM dd, yyyy');
    var formatter2 = new DateFormat('hh:mm a');
    DateTime dt = DateTime.parse(dateTime);
    if (dt.day == DateTime.now().day)
      return formatter2.format(dt);
    else
      return formatter.format(dt);
  }
}
