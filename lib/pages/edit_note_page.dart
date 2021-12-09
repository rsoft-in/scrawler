import 'package:bnotes/constants.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/models/note_list_model.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/widgets/note_edit_list_textfield.dart';
import 'package:bnotes/widgets/note_edit_title_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:line_icons/line_icons.dart';
import 'package:uuid/uuid.dart';

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
    bool darkModeOn = brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Builder(builder: (context) {
        return new Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            actions: [],
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
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _noteTextController,
                      focusNode: contentFocusNode,
                      maxLines: null,
                      onSubmitted: (value) {
                        contentFocusNode.requestFocus();
                      },
                      decoration: InputDecoration(
                        hintText: 'sad',
                        isCollapsed: true,
                        fillColor: Colors.transparent,
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                      ),
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
