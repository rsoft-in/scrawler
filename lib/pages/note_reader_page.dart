import 'dart:convert';

import 'package:bnotes/constants.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/helpers/note_color.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/note_list_model.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/pages/edit_note_page.dart';
import 'package:bnotes/pages/labels_page.dart';
import 'package:bnotes/widgets/color_palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:universal_platform/universal_platform.dart';

class NoteReaderPage extends StatefulWidget {
  final Notes note;
  const NoteReaderPage({Key? key, required this.note}) : super(key: key);

  @override
  _NoteReaderPageState createState() => _NoteReaderPageState();
}

class _NoteReaderPageState extends State<NoteReaderPage> {
  late Notes note;
  final dbHelper = DatabaseHelper.instance;
  ScrollController scrollController = new ScrollController();
  String currentEditingNoteId = "";
  List<String> _checkList = [];
  List<NoteListItem> _noteList = [];

  int selectedPageColor = 0;

  void _updateColor(String noteId, int noteColor) async {
    print(noteColor);
    await dbHelper.updateNoteColor(noteId, noteColor).then((value) {
      setState(() {
        selectedPageColor = noteColor;
      });
    });
  }

  void _deleteNote() async {
    await dbHelper.deleteNotes(currentEditingNoteId).then((value) {
      _onBackPressed();
    });
  }

  void _archiveNote(int archive) async {
    await dbHelper.archiveNote(currentEditingNoteId, archive).then((value) {
      _onBackPressed();
    });
  }

  void _noteToList() {
    if (note.noteText.contains('{')) {
      _checkList = note.noteText.replaceAll('[CHECKBOX]\n', '').split('\n');
      final parsed = json.decode(note.noteText).cast<Map<String, dynamic>>();
      _noteList = parsed
          .map<NoteListItem>((json) => NoteListItem.fromJson(json))
          .toList();
    }
  }

  @override
  void initState() {
    selectedPageColor = widget.note.noteColor;
    note = widget.note;
    _noteToList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: NoteColor.getColor(selectedPageColor, darkModeOn),
        appBar: AppBar(
          elevation: 1,
          backgroundColor: NoteColor.getColor(selectedPageColor, darkModeOn),
          leading: IconButton(
            onPressed: () => Navigator.pop(context, true),
            icon: UniversalPlatform.isIOS
                ? Icon(CupertinoIcons.back)
                : Icon(Icons.arrow_back),
            color: darkModeOn && selectedPageColor == 0
                ? Colors.white
                : Colors.black,
          ),
          actions: [
            IconButton(
              onPressed: () {
                _showEdit(context, note);
              },
              color: darkModeOn && selectedPageColor == 0
                  ? Colors.white
                  : Colors.black,
              icon: Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: () {
                _showColorPalette(context, note);
              },
              color: darkModeOn && selectedPageColor == 0
                  ? Colors.white
                  : Colors.black,
              icon: Icon(Icons.palette_outlined),
            ),
            IconButton(
              onPressed: () {
                _assignLabel(note);
              },
              color: darkModeOn && selectedPageColor == 0
                  ? Colors.white
                  : Colors.black,
              icon: Icon(Icons.new_label_outlined),
            ),
            // Archive
            Visibility(
              visible: note.noteArchived == 0,
              child: IconButton(
                tooltip: 'Archive',
                onPressed: () {
                  setState(() {
                    currentEditingNoteId = note.noteId;
                  });
                  _archiveNote(1);
                },
                color: darkModeOn && selectedPageColor == 0
                    ? Colors.white
                    : Colors.black,
                icon: Icon(Icons.archive_outlined),
              ),
            ),
            Visibility(
              visible: note.noteArchived == 1,
              child: IconButton(
                tooltip: 'Unarchive',
                onPressed: () {
                  setState(() {
                    currentEditingNoteId = note.noteId;
                  });
                  _archiveNote(0);
                },
                color: darkModeOn && selectedPageColor == 0
                    ? Colors.white
                    : Colors.black,
                icon: Icon(Icons.archive_rounded),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentEditingNoteId = note.noteId;
                });
                _confirmDelete();
              },
              color: darkModeOn && selectedPageColor == 0
                  ? Colors.white
                  : Colors.black,
              icon: Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
        body: note.noteText.contains('{')
            ? Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Visibility(
                            visible: note.noteTitle.isNotEmpty && index == 0,
                            child: Container(
                              padding: kGlobalOuterPadding,
                              margin: EdgeInsets.only(left: 8, top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                note.noteTitle,
                                style: TextStyle(
                                    color: darkModeOn && selectedPageColor == 0
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          // CheckboxListTile(
                          //   value: _noteList[index].checked == 'true',
                          //   activeColor: darkModeOn && selectedPageColor == 0
                          //       ? Colors.white
                          //       : Colors.black,
                          //   checkColor: darkModeOn && selectedPageColor == 0
                          //       ? Colors.black
                          //       : Colors.white,

                          //   title: Text(_noteList[index].value),
                          //   controlAffinity: ListTileControlAffinity.leading,
                          //   onChanged: (checked) {
                          //     setState(() {
                          //       if (_noteList[index].checked == 'true')
                          //         _noteList[index].checked = 'false';
                          //       else
                          //         _noteList[index].checked = 'true';

                          //       _saveNote();
                          //     });
                          //   },
                          // ),
                          ListTile(
                            leading: Checkbox(
                                value: _noteList[index].checked == 'true',
                                onChanged: (checked) {
                                  setState(() {
                                    if (_noteList[index].checked == 'true')
                                      _noteList[index].checked = 'false';
                                    else
                                      _noteList[index].checked = 'true';

                                    _saveNote();
                                  });
                                },
                                checkColor: darkModeOn && selectedPageColor == 0
                                    ? Colors.black
                                    : Colors.white,
                                activeColor:
                                    darkModeOn && selectedPageColor == 0
                                        ? Colors.white
                                        : Colors.black,
                                fillColor: MaterialStateProperty.all(
                                  darkModeOn && selectedPageColor == 0
                                      ? Colors.white
                                      : Colors.black,
                                )),
                            title: Text(
                              _noteList[index].value,
                              style: TextStyle(
                                color: darkModeOn && selectedPageColor == 0
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: _noteList.length,
                  )),
                ],
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Visibility(
                        visible: note.noteTitle.isNotEmpty,
                        child: Container(
                          padding: kGlobalOuterPadding,
                          margin: EdgeInsets.only(left: 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            note.noteTitle,
                            style: TextStyle(
                                color: darkModeOn && selectedPageColor == 0
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !note.noteText.contains('('),
                        child: Container(
                          padding: kGlobalOuterPadding,
                          margin: EdgeInsets.only(left: 8),
                          alignment: Alignment.centerLeft,
                          child: HtmlWidget(
                            note.noteText.replaceAll('\n', '<br>'),
                            // textAlign: TextAlign.start,
                            textStyle: TextStyle(
                                color: darkModeOn && selectedPageColor == 0
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    note.noteLabel.replaceAll(",", ", "),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: darkModeOn && selectedPageColor == 0
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                Text(Utility.formatDateTime(note.noteDate),
                    style: TextStyle(
                      color: darkModeOn ? Colors.white : Colors.black,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveNote() async {
    var _noteJson = jsonEncode(_noteList.map((e) => e.toJson()).toList());
    Notes _note = new Notes(
        note.noteId,
        note.noteDate,
        note.noteTitle,
        _noteJson,
        note.noteLabel,
        note.noteArchived,
        note.noteColor,
        note.noteList);
    await dbHelper.updateNotes(_note).then((value) {});
    print(_noteJson);
  }

  void _showEdit(BuildContext context, Notes _note) async {
    final res = await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new EditNotePage(
              note: _note,
            )));
    setState(() {
      note = res;
      _noteToList();
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
                          color: NoteColor.getColor(0, darkModeOn),
                          onTap: () {
                            _updateColor(_note.noteId, 0);
                            Navigator.pop(context);
                          },
                          isSelected: selectedPageColor == 0,
                        ),
                        ColorPalette(
                          color: NoteColor.getColor(1, darkModeOn),
                          onTap: () {
                            _updateColor(_note.noteId, 1);
                            Navigator.pop(context);
                          },
                          isSelected: selectedPageColor == 1,
                        ),
                        ColorPalette(
                          color: NoteColor.getColor(2, darkModeOn),
                          onTap: () {
                            _updateColor(_note.noteId, 2);
                            Navigator.pop(context);
                          },
                          isSelected: selectedPageColor == 2,
                        ),
                        ColorPalette(
                          color: NoteColor.getColor(3, darkModeOn),
                          onTap: () {
                            _updateColor(_note.noteId, 3);
                            Navigator.pop(context);
                          },
                          isSelected: selectedPageColor == 3,
                        ),
                        ColorPalette(
                          color: NoteColor.getColor(4, darkModeOn),
                          onTap: () {
                            _updateColor(_note.noteId, 4);
                            Navigator.pop(context);
                          },
                          isSelected: selectedPageColor == 4,
                        ),
                        ColorPalette(
                          color: NoteColor.getColor(5, darkModeOn),
                          onTap: () {
                            _updateColor(_note.noteId, 5);
                            Navigator.pop(context);
                          },
                          isSelected: selectedPageColor == 5,
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
                child: Card(
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
            ),
          );
        });
  }

  void _assignLabel(Notes note) async {
    bool res = await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new LabelsPage(
              noteid: note.noteId,
              notelabel: note.noteLabel,
            )));
    // if (res) loadNotes();
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context, true);
    return false;
  }
}
