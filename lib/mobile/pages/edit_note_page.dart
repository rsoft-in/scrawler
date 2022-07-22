import 'package:bnotes/common/constants.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/models/note_list_model.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/widgets/note_edit_list_textfield.dart';
import 'package:bnotes/widgets/small_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class EditNotePage extends StatefulWidget {
  final Notes note;

  const EditNotePage({Key? key, required this.note}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();
  TextEditingController _noteTitleController = new TextEditingController();
  TextEditingController _noteTextController = new TextEditingController();
  TextEditingController _noteListTextController = new TextEditingController();
  bool _noteListCheckValue = false;
  String currentEditingNoteId = "";
  String _noteListJsonString = "";
  final dbHelper = DatabaseHelper.instance;
  var uuid = Uuid();
  late Notes note;
  bool isCheckList = false;
  List<NoteListItem> _noteListItems = [];

  void _saveNote() async {
    if (currentEditingNoteId.isEmpty) {
      setState(() {
        note = new Notes(
            uuid.v1(),
            DateTime.now().toString(),
            _noteTitleController.text,
            _noteTextController.text,
            '',
            0,
            0,
            _noteListJsonString);
      });
      await dbHelper.insertNotes(note).then((value) {
        // loadNotes();
      });
    } else {
      setState(() {
        note = new Notes(
            currentEditingNoteId,
            DateTime.now().toString(),
            _noteTitleController.text,
            _noteTextController.text,
            '',
            0,
            0,
            _noteListJsonString);
      });
      await dbHelper.updateNotes(note).then((value) {
        // loadNotes();
      });
    }
  }

  void onSubmitListItem() async {
    _noteListItems.add(new NoteListItem(_noteListTextController.text, 'false'));
    _noteListTextController.text = "";
    print(_noteListCheckValue);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      note = widget.note;
      _noteTextController.text = note.noteText;
      _noteTitleController.text = note.noteTitle;
      currentEditingNoteId = note.noteId;
      isCheckList = note.noteList.contains('{');
    });
    titleFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Builder(builder: (context) {
        return new Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: SAppBar(
              title: '',
              onTap: _onBackPressed,
            ),
          ),
          body: GestureDetector(
            onTap: () {
              contentFocusNode.requestFocus();
            },
            child: Padding(
              padding: kGlobalOuterPadding,
              child: ListView(
                children: [
                  // Padding(
                  //   padding: kGlobalOuterPadding,
                  //   child: Container(
                  //     child: NoteEditTextField(
                  //       controller: _noteTitleController,
                  //       hint: 'Title',
                  //       focusNode: titleFocusNode,
                  //       onSubmitFocusNode: contentFocusNode,
                  //     ),
                  //   ),
                  // ),
                  TextField(
                    controller: _noteTitleController,
                    focusNode: titleFocusNode,
                    onSubmitted: (value) {
                      contentFocusNode.requestFocus();
                    },
                    decoration: InputDecoration(
                      hintText: 'Title',
                      // label: Text('Title'),
                      // isCollapsed: true,
                      fillColor: Colors.transparent,
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 1.2,
                    endIndent: 10,
                    indent: 10,
                  ),
                  // TextField(
                  //   controller: _noteTextController,
                  //   focusNode: contentFocusNode,
                  //   maxLines: null,
                  //   onSubmitted: (value) {
                  //     contentFocusNode.requestFocus();
                  //   },
                  //   decoration: InputDecoration(
                  //     hintText: 'sad',
                  //     border: OutlineInputBorder(
                  //         borderSide:
                  //             BorderSide(width: 10, color: Colors.white)),
                  //   ),
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _noteTextController,
                    focusNode: contentFocusNode,
                    maxLines: null,
                    onSubmitted: (value) {
                      contentFocusNode.requestFocus();
                    },
                    decoration: InputDecoration(
                      hintText: 'Content',
                      fillColor: Colors.transparent,
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                  // Padding(
                  //   padding: kGlobalOuterPadding,
                  //   child: Container(
                  //     child: NoteEditTextField(
                  //       controller: _noteTextController,
                  //       hint: 'Content',
                  //       focusNode: contentFocusNode,
                  //       isContentField: true,
                  //     ),
                  //   ),
                  // ),
                  if (isCheckList)
                    ...List.generate(
                        _noteListItems.length, generatenoteListItems),
                  // ListView.builder(
                  //   itemBuilder: (context, index) {
                  //     return ListTile();
                  //   },
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  // ),
                  Visibility(
                    visible: isCheckList,
                    child: NoteEditListTextField(
                      checkValue: _noteListCheckValue,
                      controller: _noteListTextController,
                      onSubmit: () => onSubmitListItem(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // bottomNavigationBar: BottomAppBar(
          //   child: Container(
          //     // padding: EdgeInsets.all(value),
          //     margin: EdgeInsets.only(
          //         bottom: MediaQuery.of(context).viewInsets.bottom),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         IconButton(
          //           onPressed: () {
          //             setState(() {
          //               isCheckList = !isCheckList;
          //             });
          //           },
          //           icon: Icon(isCheckList
          //               ? Icons.text_format
          //               : Icons.check_box_outlined),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        );
      }),
    );
  }

  Widget generatenoteListItems(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      child: Row(
        children: [
          Icon(Icons.check_box),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: Text(_noteListItems[index].value),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (_noteTextController.text.isNotEmpty) {
      _saveNote();
      Navigator.pop(context, note);
    } else {
      Navigator.pop(context, false);
    }
    return false;
  }
}
