import 'package:bnotes/helpers/dbhelper.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../desktop_web/markdown_toolbar.dart';
import '../helpers/constants.dart';
import '../models/notes.dart';

class MobileNotePage extends StatefulWidget {
  final Notes note;
  const MobileNotePage(this.note, {Key? key}) : super(key: key);

  @override
  State<MobileNotePage> createState() => _MobileNotePageState();
}

class _MobileNotePageState extends State<MobileNotePage> {
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
    print('inside save method');
    if (widget.note.noteId.isEmpty) {
      var uid = const Uuid();
      final newNote = Notes(uid.v1(), Utility.getDateString(),
          noteTitleController.text, noteController.text, '', false, 0, '');
      print(newNote.toJson());
      final res = await dbHelper.insertNotes(newNote);
      print('Note inserted $res');
    } else {
      _note.noteText = noteController.text;
      final res = await dbHelper.updateNotes(_note);
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
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Symbols.arrow_back)),
          title: GestureDetector(
            onTap: () => editTile(),
            child: Text(_note.noteTitle),
          ),
          actions: [
            IconButton(
                onPressed: () => saveNote(), icon: const Icon(Symbols.check)),
            PopupMenuButton(
              icon: const Icon(Symbols.more_horiz),
              itemBuilder: (context) => [
                const PopupMenuItem(child: Text('Color')),
                const PopupMenuItem(child: Text('Label')),
              ],
            ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: editMode,
              child: Expanded(
                child: Padding(
                  padding: kPaddingLarge,
                  child: TextField(
                    controller: noteController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: 'Start writing something...',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
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
      ),
    );
  }

  void editTile() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Title'),
          actions: [
            FilledButton(
              onPressed: () {
                updateTile();
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
          content: Padding(
            padding: kPaddingMedium,
            child: TextField(
              autofocus: true,
              maxLength: 50,
              controller: noteTitleController,
              decoration: const InputDecoration(
                counterText: '',
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
