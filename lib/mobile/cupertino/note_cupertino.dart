import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/constants.dart';
import '../../helpers/dbhelper.dart';
import '../../helpers/utility.dart';
import '../../models/notes.dart';
import '../markdown_toolbar.dart';

class NotePageCupertino extends StatefulWidget {
  final Notes note;
  const NotePageCupertino(this.note, {super.key});

  @override
  State<NotePageCupertino> createState() => _NotePageCupertinoState();
}

class _NotePageCupertinoState extends State<NotePageCupertino> {
  bool editMode = false;
  bool wasEdited = false;
  Notes _note = Notes.empty();
  TextEditingController noteController = TextEditingController();
  TextEditingController noteTitleController = TextEditingController();
  DBHelper dbHelper = DBHelper.instance;

  void updateTile() {
    setState(() {
      _note.noteTitle = noteTitleController.text;
    });
  }

  Future<void> saveNote() async {
    if (widget.note.noteId.isEmpty) {
      var uid = const Uuid();
      final newNote = Notes(
          uid.v1(),
          Utility.getDateString(),
          noteTitleController.text,
          noteController.text,
          '',
          false,
          0,
          '',
          false);
      await dbHelper.insertNotes(newNote);
    } else {
      _note.noteText = noteController.text;
      _note.noteDate = Utility.getDateString();
      await dbHelper.updateNotes(_note);
    }
  }

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    noteTitleController.text = _note.noteTitle;
    noteController.text = _note.noteText;
    if (_note.noteId.isEmpty) {
      editMode = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (wasEdited || (widget.note.noteId.isNotEmpty))
          ? (didPop) => saveNote()
          : null,
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: GestureDetector(
                onTap: () => editTile(), child: Text(_note.noteTitle)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Visibility(
                  visible: editMode,
                  child: Expanded(
                    child: Padding(
                      padding: kPaddingLarge,
                      child: CupertinoTextField.borderless(
                        controller: noteController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        placeholder: 'Start writing something...',
                        onChanged: (value) {
                          setState(() {
                            widget.note.noteText = value;
                            if (!wasEdited) {
                              wasEdited = true;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !editMode,
                  child: Expanded(
                    child: GestureDetector(
                      onDoubleTap: () => setState(() {
                        editMode = true;
                      }),
                      child: Markdown(
                        data: widget.note.noteText,
                        onTapLink: (text, href, title) async =>
                            await _launchUrl(href),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: editMode,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MarkdownToolbar(controller: noteController),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void editTile() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Title'),
            content: Padding(
              padding: kPaddingMedium,
              child: CupertinoTextField(
                autofocus: true,
                controller: noteTitleController,
              ),
            ),
            actions: [
              CupertinoButton(
                onPressed: () {
                  updateTile();
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
              CupertinoButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
