import 'package:bnotes/helpers/dbhelper.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/mobile/material/label_select_material.dart';
import 'package:bnotes/widgets/rs_button.dart';
import 'package:bnotes/widgets/rs_text_button.dart';
import 'package:bnotes/widgets/scrawl_color_dot.dart';
import 'package:bnotes/widgets/scrawl_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/constants.dart';
import '../../models/notes.dart';
import '../markdown_toolbar.dart';

class NotePageMaterial extends StatefulWidget {
  final Notes note;
  const NotePageMaterial(this.note, {super.key});

  @override
  State<NotePageMaterial> createState() => _NotePageMaterialState();
}

class _NotePageMaterialState extends State<NotePageMaterial> {
  bool editMode = false;
  bool wasEdited = false;
  Notes _note = Notes.empty();
  TextEditingController noteController = TextEditingController();
  UndoHistoryController undoController = UndoHistoryController();
  TextEditingController noteTitleController = TextEditingController();
  int noteColor = 0;
  bool favorite = false;
  String noteLabel = "";
  DBHelper dbHelper = DBHelper.instance;
  FocusNode editorFocusNode = FocusNode();

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
          noteLabel,
          false,
          noteColor,
          '',
          favorite);
      await dbHelper.insertNotes(newNote);
    } else {
      _note.noteText = noteController.text;
      _note.noteDate = Utility.getDateString();
      _note.noteColor = noteColor;
      _note.noteFavorite = favorite;
      _note.noteLabel = noteLabel;
      await dbHelper.updateNotes(_note);
    }
    setState(() {
      wasEdited = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    noteTitleController.text = _note.noteTitle;
    noteController.text = _note.noteText;
    noteColor = _note.noteColor;
    favorite = _note.noteFavorite;
    noteLabel = _note.noteLabel;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_note.noteTitle),
                if (noteLabel.isNotEmpty)
                  Text(
                    noteLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            if (!editMode) ScrawlColorDot(colorCode: noteColor),
            if (!editMode)
              IconButton(
                  onPressed: () => setState(() {
                        favorite = !favorite;
                      }),
                  icon: favorite
                      ? const Icon(Symbols.favorite, fill: 1)
                      : const Icon(Symbols.favorite)),
            if (!editMode)
              PopupMenuButton(
                icon: const Icon(Symbols.more_horiz),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Color'),
                    onTap: () => Future.delayed(
                      const Duration(milliseconds: 500),
                      () => editColor(),
                    ),
                  ),
                  PopupMenuItem(
                    child: const Text('Label'),
                    onTap: () => Future.delayed(
                      const Duration(milliseconds: 500),
                      () => assignLabel(),
                    ),
                  ),
                ],
              ),
            if (editMode)
              TextButton(
                onPressed: () {
                  saveNote();
                  setState(() {
                    editMode = !editMode;
                  });
                },
                child: const Text('Done'),
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
                    undoController: undoController,
                    maxLines: null,
                    expands: true,
                    focusNode: editorFocusNode,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Start writing something...',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    onChanged: (value) {
                      print('note has been edited');
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
                    editorFocusNode.requestFocus();
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
                child: MarkdownToolbar(
                  controller: noteController,
                  undoController: undoController,
                  onChange: () => setState(() {
                    if (!wasEdited) {
                      wasEdited = true;
                      print('note has been edited');
                    }
                  }),
                ),
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
              RSButton(
                onPressed: () {
                  updateTile();
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
              RSTextButton(
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
        });
  }

  Future<void> editColor() async {
    final colorCode = await showDialog(
        context: context,
        builder: (context) {
          return const ScrawlColorPicker();
        });
    if (colorCode != null) {
      setState(() {
        noteColor = colorCode;
      });
    }
  }

  Future<void> assignLabel() async {
    final labelName = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const LabelSelectMaterial()));
    if (labelName != null) {
      setState(() {
        noteLabel = labelName;
      });
    }
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
