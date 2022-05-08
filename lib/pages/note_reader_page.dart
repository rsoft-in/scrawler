import 'dart:convert';

import 'package:bnotes/common/constants.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/helpers/note_color.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/note_list_model.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/pages/edit_note_page.dart';
import 'package:bnotes/pages/labels_page.dart';
import 'package:bnotes/widgets/color_palette_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

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
  bool isDesktop = false;

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
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    print(note.toJson());
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: NoteColor.getColor(selectedPageColor, darkModeOn),
        appBar: AppBar(
          elevation: 0.2,
          backgroundColor: NoteColor.getColor(selectedPageColor, darkModeOn)
              .withOpacity(0.6),
          leading: Container(
            margin: const EdgeInsets.all(8.0),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   color: Colors.black.withOpacity(0.1),
            // ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Icon(
                Iconsax.arrow_left_2,
                size: 15,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _showEdit(context, note);
              },
              color: Colors.black,
              icon: Icon(Iconsax.edit_2),
            ),
            IconButton(
              onPressed: () {
                _showColorPalette(context, note);
              },
              color: Colors.black,
              icon: Icon(Iconsax.color_swatch),
            ),
            IconButton(
              onPressed: () {
                _assignLabel(note);
              },
              color: Colors.black,
              icon: Icon(Iconsax.tag),
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
                color: Colors.black,
                icon: Icon(Iconsax.archive_add),
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
                color: Colors.black,
                icon: Icon(Iconsax.archive_minus),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentEditingNoteId = note.noteId;
                });
                _confirmDelete();
              },
              color: Colors.black,
              icon: Icon(Iconsax.note_remove),
            )
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
                                    color: Colors.black,
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
                controller: scrollController,
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
                                color: Colors.black,
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
                          child: MarkdownBody(
                            styleSheet: MarkdownStyleSheet(
                              a: TextStyle(
                                  color: Colors.purple,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600),
                              p: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            selectable: true,
                            shrinkWrap: true,
                            onTapLink: (text, href, title) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actionsPadding: EdgeInsets.all(10),
                                      title: Text('Attention!'),
                                      content:
                                          Text('Do you want to open the link?'),
                                      actions: [
                                        OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (await canLaunch(href!)) {
                                              await launch(
                                                href,
                                                forceSafariVC: false,
                                                forceWebView: false,
                                              );
                                              Navigator.pop(context);
                                            } else {
                                              throw 'Could not launch';
                                            }
                                          },
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            data: note.noteText,
                            softLineBreak: true,
                            fitContent: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent.withOpacity(0.1),
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
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(Utility.formatDateTime(note.noteDate),
                    style: TextStyle(
                      color: Colors.black,
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
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    isDesktop = isDisplayDesktop(context);
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        constraints: isDesktop
            ? BoxConstraints(maxWidth: 450, minWidth: 400)
            : BoxConstraints(),
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Padding(
              padding: kGlobalOuterPadding,
              child: Container(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  children: [
                    ColorPaletteButton(
                      color: NoteColor.getColor(0, darkModeOn),
                      onTap: () {
                        _updateColor(_note.noteId, 0);
                        Navigator.pop(context);
                      },
                      isSelected: selectedPageColor == 0,
                    ),
                    ColorPaletteButton(
                      color: NoteColor.getColor(1, darkModeOn),
                      onTap: () {
                        _updateColor(_note.noteId, 1);
                        Navigator.pop(context);
                      },
                      isSelected: selectedPageColor == 1,
                    ),
                    ColorPaletteButton(
                      color: NoteColor.getColor(2, darkModeOn),
                      onTap: () {
                        _updateColor(_note.noteId, 2);
                        Navigator.pop(context);
                      },
                      isSelected: selectedPageColor == 2,
                    ),
                    ColorPaletteButton(
                      color: NoteColor.getColor(3, darkModeOn),
                      onTap: () {
                        _updateColor(_note.noteId, 3);
                        Navigator.pop(context);
                      },
                      isSelected: selectedPageColor == 3,
                    ),
                    ColorPaletteButton(
                      color: NoteColor.getColor(4, darkModeOn),
                      onTap: () {
                        _updateColor(_note.noteId, 4);
                        Navigator.pop(context);
                      },
                      isSelected: selectedPageColor == 4,
                    ),
                    ColorPaletteButton(
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
          );
        });
  }

  void _confirmDelete() async {
    isDesktop = isDisplayDesktop(context);
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        constraints: isDesktop
            ? BoxConstraints(maxWidth: 450, minWidth: 400)
            : BoxConstraints(),
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Padding(
              padding: kGlobalOuterPadding,
              child: Container(
                height: 160,
                child: Padding(
                  padding: kGlobalOuterPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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

  void _assignLabel(Notes _note) async {
    var res = await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new LabelsPage(
              noteid: _note.noteId,
              notelabel: _note.noteLabel,
            )));
    if (res != null) {
      setState(() {
        note.noteLabel = res;
      });
    }
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context, true);
    return false;
  }
}
