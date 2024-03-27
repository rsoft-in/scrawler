import 'package:bnotes/helpers/dbhelper.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/mobile/material/label_select_material.dart';
import 'package:bnotes/widgets/scrawl_color_dot.dart';
import 'package:bnotes/widgets/scrawl_color_picker.dart';
import 'package:bnotes/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/constants.dart';
import '../../models/notes.dart';
import '../markdown_toolbar.dart';

class NotePageMaterial extends StatefulWidget {
  final Notes note;
  final String? preferedLabel;
  const NotePageMaterial(this.note, this.preferedLabel, {super.key});

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
  late SharedPreferences prefs;
  late FToast fToast;

  void checkHelperPreference() async {
    prefs = await SharedPreferences.getInstance();
    bool helperDisplayed = prefs.getBool('double_tap_intro') ?? false;
    if (!helperDisplayed && !editMode) {
      fToast.showToast(
          child: const ScrawlToast('Double Tap on the Note to Edit it!'));
      prefs.setBool('double_tap_intro', true);
    }
  }

  void updateTile(String value) {
    setState(() {
      _note.noteTitle = value;
      if (!wasEdited) {
        wasEdited = true;
      }
    });
  }

  Future<void> saveNote() async {
    if (_note.noteId.isEmpty) {
      var uid = const Uuid();
      final newNote = Notes(
          uid.v1(),
          Utility.getDateString(),
          noteTitleController.text.isEmpty
              ? 'Untitled'
              : noteTitleController.text,
          noteController.text,
          noteLabel,
          false,
          noteColor,
          '',
          favorite);
      _note = newNote;
      await dbHelper.insertNotes(newNote);
    } else {
      _note.noteTitle = noteTitleController.text.isEmpty
          ? 'Untitled'
          : noteTitleController.text;
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
    checkHelperPreference();
    _note = widget.note;
    noteTitleController.text =
        _note.noteTitle.toLowerCase() == 'untitled' ? '' : _note.noteTitle;
    noteController.text = _note.noteText;
    noteColor = _note.noteColor;
    favorite = _note.noteFavorite;
    noteLabel = (widget.preferedLabel != null)
        ? widget.preferedLabel!
        : _note.noteLabel;
    if (_note.noteId.isEmpty) {
      editMode = true;
    }
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (wasEdited) ? (didPop) => saveNote() : null,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Symbols.arrow_back)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _note.noteTitle,
                style: const TextStyle(fontSize: 18),
              ),
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
          actions: [
            if (!editMode) ScrawlColorDot(colorCode: noteColor),
            if (!editMode)
              IconButton(
                  onPressed: () => setState(() {
                        favorite = !favorite;
                        if (!wasEdited) {
                          wasEdited = true;
                        }
                      }),
                  icon: favorite
                      ? Icon(
                          Symbols.favorite,
                          fill: 1,
                          color: Colors.red.shade300,
                        )
                      : const Icon(Symbols.favorite)),
            if (!editMode)
              PopupMenuButton(
                icon: const Icon(Symbols.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Symbols.color_lens),
                        kHSpace,
                        Expanded(child: Text('Color')),
                      ],
                    ),
                    onTap: () => Future.delayed(
                      const Duration(milliseconds: 500),
                      () => editColor(),
                    ),
                  ),
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Symbols.folder),
                        kHSpace,
                        Text('Move to'),
                      ],
                    ),
                    onTap: () => Future.delayed(
                      const Duration(milliseconds: 500),
                      () => assignLabel(),
                    ),
                  ),
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Symbols.delete),
                        kHSpace,
                        Text('Delete'),
                      ],
                    ),
                    onTap: () {},
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: noteTitleController,
                    style: const TextStyle(fontSize: 24),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    onChanged: (value) => updateTile(value),
                  ),
                )),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    widget.note.noteTitle,
                    style: const TextStyle(fontSize: 24),
                  ),
                )),
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

  Future<void> editColor() async {
    final colorCode = await showDialog(
        context: context,
        builder: (context) {
          return const ScrawlColorPicker();
        });
    if (colorCode != null) {
      setState(() {
        noteColor = colorCode;
        wasEdited = true;
      });
    }
  }

  Future<void> assignLabel() async {
    final labelName = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const LabelSelectMaterial()));
    if (labelName != null) {
      setState(() {
        noteLabel = labelName;
        wasEdited = true;
      });
    }
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
