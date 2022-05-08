import 'dart:convert';

import 'package:bnotes/common/constants.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/helpers/note_color.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/note_list_model.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/pages/app.dart';
import 'package:bnotes/pages/note_reader_page.dart';
import 'package:bnotes/widgets/note_card_grid.dart';
import 'package:bnotes/widgets/note_card_list.dart';
import 'package:bnotes/widgets/note_listview_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  late SharedPreferences sharedPreferences;
  List<Notes> notesList = [];
  bool isLoading = false;
  bool hasData = false;
  late ViewType _viewType;

  TextEditingController _searchController = new TextEditingController();
  final dbHelper = DatabaseHelper.instance;

  int selectedPageColor = 1;

  bool isDesktop = false;

  loadArchiveNotes() async {
    setState(() {
      isLoading = true;
    });

    await dbHelper.getNotesArchived(_searchController.text).then((value) {
      setState(() {
        print(value.length);
        isLoading = false;
        hasData = value.length > 0;
        notesList = value;
      });
    });
  }

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      bool isTile = sharedPreferences.getBool("is_tile") ?? false;
      _viewType = isTile ? ViewType.Tile : ViewType.Grid;
    });
  }

  @override
  void initState() {
    getPref();
    loadArchiveNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    isDesktop = isDisplayDesktop(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 100.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Archive',
                  style: TextStyle(
                    color: darkModeOn ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                titlePadding: EdgeInsets.only(left: 30, bottom: 15),
              ),
            ),
          ];
        },
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // SizedBox(
              //   height: 56,
              // ),
              // Padding(
              //   padding: kGlobalOuterPadding,
              //   child: Container(
              //     child: Text(
              //       'Archive',
              //       style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              //     ),
              //   ),
              // ),
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : (hasData
                        ? (_viewType == ViewType.Grid
                            ? StaggeredGridView.countBuilder(
                                crossAxisCount: isDesktop ? 4 : 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                // shrinkWrap: true,
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
                                    final parsed = json
                                        .decode(note.noteText)
                                        .cast<Map<String, dynamic>>();
                                    _noteList = parsed
                                        .map<NoteListItem>((json) =>
                                            NoteListItem.fromJson(json))
                                        .toList();
                                  }
                                  return NoteCardGrid(
                                    note: note,
                                    onTap: () {
                                      setState(() {
                                        selectedPageColor = note.noteColor;
                                      });
                                      _showNoteReader(context, note);
                                    },
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
                                        .map<NoteListItem>((json) =>
                                            NoteListItem.fromJson(json))
                                        .toList();
                                  }
                                  return NoteCardList(
                                    note: note,
                                    onTap: () {
                                      setState(() {
                                        selectedPageColor = note.noteColor;
                                      });
                                      _showNoteReader(context, note);
                                    },
                                  );
                                },
                              ))
                        : Container(
                            alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 150,
                                ),
                                Icon(
                                  Iconsax.archive_minus,
                                  size: 120,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'empty!',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 22),
                                ),
                              ],
                            ),
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getDateString() {
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime dt = DateTime.now();
    return formatter.format(dt);
  }

  // void _showOptionsSheet(BuildContext context, Notes _note) {
  //   showModalBottomSheet(
  //       context: context,
  //       backgroundColor: Colors.transparent,
  //       isDismissible: true,
  //       builder: (context) {
  //         return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setModalState) {
  //             return Container(
  //               alignment: Alignment.bottomCenter,
  //               child: Container(
  //                 child: Padding(
  //                   padding: kGlobalOuterPadding,
  //                   child: Card(
  //                     child: Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: <Widget>[
  //                         InkWell(
  //                           onTap: () {
  //                             Navigator.of(context).pop();
  //                             setState(() {
  //                               _noteTextController.text = _note.noteText;
  //                               _noteTitleController.text = _note.noteTitle;
  //                               currentEditingNoteId = _note.noteId;
  //                             });
  //                             _showEdit(context);
  //                           },
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Row(
  //                               children: <Widget>[
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Icon(Icons.edit_outlined),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text('Edit'),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             Navigator.pop(context);
  //                             // _assignLabel(_note);
  //                             _showColorPalette(context, _note);
  //                           },
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Row(
  //                               children: <Widget>[
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Icon(Icons.palette_outlined),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text('Color Palette'),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             Navigator.pop(context);
  //                             _assignLabel(_note);
  //                           },
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Row(
  //                               children: <Widget>[
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Icon(Icons.new_label_outlined),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text('Assign Labels'),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             Navigator.of(context).pop();
  //                             setState(() {
  //                               currentEditingNoteId = _note.noteId;
  //                             });
  //                             _confirmDelete();
  //                           },
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Row(
  //                               children: <Widget>[
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Icon(Icons.delete_outline_rounded),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text('Delete'),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             Navigator.pop(context);
  //                           },
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Row(
  //                               children: <Widget>[
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Icon(Icons.clear),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text('Cancel'),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       });
  // }

  void _showNoteReader(BuildContext context, Notes _note) async {
    isDesktop = isDisplayDesktop(context);
    if (isDesktop) {
      bool res = await showDialog(
          context: context,
          builder: (context) {
            return Container(
              child: Dialog(
                child: Container(
                  width: isDesktop ? 800 : MediaQuery.of(context).size.width,
                  child: NoteReaderPage(
                    note: _note,
                  ),
                ),
              ),
            );
          });
      if (res) loadArchiveNotes();
    } else {
      bool res = await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new NoteReaderPage(
                note: _note,
              )));
      if (res) loadArchiveNotes();
    }
  }
}
