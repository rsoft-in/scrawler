import 'package:bnotes/constants.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EditNotePage extends StatefulWidget {
  final Notes note;
  const EditNotePage({Key? key, required this.note}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  TextEditingController _noteTitleController = new TextEditingController();
  TextEditingController _noteTextController = new TextEditingController();
  String currentEditingNoteId = "";
  final dbHelper = DatabaseHelper.instance;
  var uuid = Uuid();
  late Notes note;

  void _saveNote() async {
    if (currentEditingNoteId.isEmpty) {
      setState(() {
        note = new Notes(uuid.v1(), DateTime.now().toString(),
            _noteTitleController.text, _noteTextController.text, '', 0, 0);
      });
      await dbHelper.insertNotes(note).then((value) {
        // loadNotes();
      });
    } else {
      setState(() {
        note = new Notes(currentEditingNoteId, DateTime.now().toString(),
            _noteTitleController.text, _noteTextController.text, '', 0, 0);
      });
      await dbHelper.updateNotes(note).then((value) {
        // loadNotes();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      note = widget.note;
      _noteTextController.text = note.noteText;
      _noteTitleController.text = note.noteTitle;
      currentEditingNoteId = note.noteId;
    });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
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
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: darkModeOn
                          ? kSecondaryDark
                          : Colors.grey.withOpacity(0.1),
                    ),
                    child: TextField(
                      controller: _noteTitleController,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Title',
                          hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Padding(
                  padding: kGlobalOuterPadding,
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      // color: darkModeOn
                      //     ? kSecondaryDark
                      //     : Colors.grey.withOpacity(0.1),
                    ),
                    // height: MediaQuery.of(context).size.height * .7,
                    child: TextField(
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _noteTextController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Write something here...',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
