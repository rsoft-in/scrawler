import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/helpers/note_color.dart';
import 'package:scrawler/src/widgets/markdown_toolbar.dart';
import 'package:scrawler/src/widgets/scrawl_color_picker.dart';
import 'package:scrawler/src/widgets/scrawl_snackbar.dart';
import 'package:uuid/uuid.dart';

import '../helpers/globals.dart' as globals;
import '../models/notes.dart';

class NoteView extends StatefulWidget {
  final Notes note;
  const NoteView({super.key, required this.note});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  Notes note = Notes.empty();
  bool editing = false;
  bool formDirty = false;
  bool hasChanges = false;

  TextEditingController noteTextController = TextEditingController();
  TextEditingController noteTitleController = TextEditingController();
  UndoHistoryController undoHistoryController = UndoHistoryController();

  Future<void> getNoteText() async {
    try {
      final response = await http.Client().post(
        Uri.parse("${globals.apiServer}/getnotetext"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {'user_id': globals.user.userId, 'note_id': widget.note.noteId},
        ),
      );
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        if (parsed.isNotEmpty) {
          setState(() {
            note.noteText = parsed[0]['note_text'];
            noteTextController.text = note.noteText;
          });
        }
      } else {
        if (mounted) showSnackBar(context, response.body);
      }
    } catch (e) {
      if (mounted) showSnackBar(context, '$e');
    }
  }

  Future<void> saveNote() async {
    final uuid = Uuid().v1();
    final isNew = note.noteId.isEmpty;
    setState(() {
      note.noteText = noteTextController.text;
      note.noteDate = DateTime.now().toIso8601String();
    });
    try {
      final response = await http.Client().post(
        Uri.parse("${globals.apiServer}/updatenote"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'is_new': isNew,
            'id': isNew ? uuid : note.noteId,
            'user_id': globals.user.userId,
            'date': note.noteDate,
            'title': note.noteTitle,
            'text': note.noteText,
            'label': note.noteLabel,
            'archived': note.noteArchived,
            'color': note.noteColor,
            'image': note.noteImage,
            'audio_file': '',
            'favorite': note.noteFavorite
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          hasChanges = true;
          formDirty = false;
          editing = false;
          if (isNew) note.noteId = uuid;
        });
      } else {
        if (mounted) showSnackBar(context, response.body);
      }
    } catch (e) {
      if (mounted) showSnackBar(context, '$e');
    }
  }

  Future<void> updateFavorite() async {
    try {
      final response = await http.Client().post(
        Uri.parse("${globals.apiServer}/updatefavnote"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {'id': note.noteId},
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          note.noteFavorite = !note.noteFavorite;
          hasChanges = true;
        });
      } else {
        if (mounted) showSnackBar(context, response.body);
      }
    } catch (e) {
      if (mounted) showSnackBar(context, '$e');
    }
  }

  Future<void> updateColor(int colorCode) async {
    try {
      final response = await http.Client().post(
        Uri.parse("${globals.apiServer}/updatenotecolor"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {'id': note.noteId, 'color': colorCode},
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          note.noteColor = colorCode;
          hasChanges = true;
        });
      } else {
        if (mounted) showSnackBar(context, response.body);
      }
    } catch (e) {
      if (mounted) showSnackBar(context, '$e');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      note = widget.note;
      editing = widget.note.noteId.isEmpty;
    });
    if (note.noteId.isNotEmpty) getNoteText();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        if (formDirty) {
          await saveNote();
        }
        if (context.mounted) {
          if (hasChanges) {
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context, false);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(note.noteTitle),
              kHSpace,
              if (editing)
                IconButton(
                  onPressed: () => showTitleEditor(),
                  icon: Icon(Symbols.edit),
                ),
            ],
          ),
          actionsPadding: EdgeInsets.only(right: 8.0),
          actions: [
            if (!editing)
              IconButton(
                onPressed: () => updateFavorite(),
                icon: Icon(
                  note.noteFavorite ? Icons.favorite : Symbols.favorite,
                  color: note.noteFavorite ? Colors.red : null,
                ),
              ),
            if (!editing)
              IconButton(
                onPressed: () => openColorPicker(),
                icon: Icon(Symbols.palette),
              ),
            if (!editing)
              IconButton(
                onPressed: () => setState(() {
                  editing = true;
                }),
                icon: Icon(Symbols.edit),
              ),
            if (editing)
              IconButton(
                onPressed: () => saveNote(),
                icon: Icon(Symbols.check),
              ),
          ],
        ),
        body: editing
            ? Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  MarkdownToolbar(
                    controller: noteTextController,
                    undoController: undoHistoryController,
                    onChange: () {},
                  ),
                  Expanded(
                    child: Padding(
                      padding: kPaddingLarge,
                      child: TextField(
                        controller: noteTextController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText: 'Write something here...',
                          filled: false,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            formDirty = true;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 5,
                    color: NoteColor.getColor(note.noteColor, false),
                  ),
                  Expanded(
                    child: Padding(
                      padding: kPaddingLarge,
                      child: Markdown(
                        padding: EdgeInsets.zero,
                        data: note.noteText,
                        selectable: true,
                        softLineBreak: true,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void showTitleEditor() async {
    noteTitleController.text = note.noteTitle;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 350),
            child: Padding(
              padding: kGlobalOuterPadding * 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        'Edit Title',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Symbols.close),
                      ),
                    ],
                  ),
                  kVSpace,
                  TextField(
                    controller: noteTitleController,
                    maxLength: 30,
                    decoration: InputDecoration(
                      hintText: 'Enter Title',
                      counterText: '',
                    ),
                  ),
                  kVSpace,
                  FilledButton(
                    onPressed: () => saveTitle(),
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void saveTitle() {
    setState(() {
      note.noteTitle = noteTitleController.text;
      formDirty = true;
    });
    Navigator.pop(context);
  }

  void openColorPicker() async {
    final colorCode = await showDialog(
      context: context,
      builder: (context) {
        return ScrawlColorPicker();
      },
    );
    if (colorCode != null) {
      updateColor(colorCode);
    }
  }
}
