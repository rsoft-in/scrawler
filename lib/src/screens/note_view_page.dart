import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/helpers/encryption_service.dart';
import 'package:scrawler/src/helpers/note_color.dart';
import 'package:scrawler/src/providers/notes_api_provider.dart';
import 'package:scrawler/src/screens/labels_page.dart';
import 'package:scrawler/src/widgets/markdown_toolbar.dart';
import 'package:scrawler/src/widgets/scrawl_color_picker.dart';
import 'package:scrawler/src/widgets/scrawl_label_chip.dart';
import 'package:scrawler/src/widgets/scrawl_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../helpers/adaptive.dart';
import '../helpers/globals.dart' as globals;
import '../helpers/utility.dart';
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
  bool isSmallDevice = false;

  TextEditingController noteTextController = TextEditingController();
  TextEditingController noteTitleController = TextEditingController();
  UndoHistoryController undoHistoryController = UndoHistoryController();

  FocusNode titleFocusNode = FocusNode();

  Future<void> getNoteText() async {
    final response = await NotesApiProvider.getNoteText(json.encode(
      {'user_id': globals.user.userId, 'note_id': widget.note.noteId},
    ));
    if (response.error.isEmpty && response.notes.isNotEmpty) {
      setState(() {
        note.noteText = response.notes[0].noteText;
        noteTextController.text = note.noteText;
      });
    } else {
      if (mounted) showSnackBar(context, response.error);
    }
  }

  Future<void> saveNote() async {
    final uuid = Uuid().v1();
    final isNew = note.noteId.isEmpty;
    setState(() {
      note.noteText = noteTextController.text;
      note.noteDate = DateTime.now().toIso8601String();
    });
    final response = await NotesApiProvider.update(json.encode(
      {
        'is_new': isNew,
        'id': isNew ? uuid : note.noteId,
        'user_id': globals.user.userId,
        'date': note.noteDate,
        'title': note.noteTitle.trim().isEmpty
            ? ''
            : EncryptionService.encrypt(note.noteTitle.trim()),
        'text': note.noteText.trim().isEmpty
            ? ''
            : EncryptionService.encrypt(note.noteText.trim()),
        'label': note.noteLabel,
        'archived': note.noteArchived,
        'color': note.noteColor,
        'image': note.noteImage,
        'audio_file': '',
        'favorite': note.noteFavorite
      },
    ));
    if (response['status']) {
      setState(() {
        hasChanges = true;
        formDirty = false;
        editing = false;
        if (isNew) note.noteId = uuid;
      });
    } else {
      if (mounted) showSnackBar(context, response['error']);
    }
  }

  Future<void> updateFavorite() async {
    final response = await NotesApiProvider.updateFavorite(json.encode(
      {'id': note.noteId},
    ));
    if (response['status']) {
      setState(() {
        note.noteFavorite = !note.noteFavorite;
        hasChanges = true;
      });
    } else {
      if (mounted) showSnackBar(context, response['error']);
    }
  }

  Future<void> updateColor(int colorCode) async {
    final response = await NotesApiProvider.updateColor(json.encode(
      {'id': note.noteId, 'color': colorCode},
    ));
    if (response['status']) {
      setState(() {
        note.noteColor = colorCode;
        hasChanges = true;
      });
    } else {
      if (mounted) showSnackBar(context, response['error']);
    }
  }

  Future<void> updateLabel(String label) async {
    final post = json.encode(
      {'id': note.noteId, 'label': label.trim()},
    );
    final response = await NotesApiProvider.updateLabel(post);
    if (response['status']) {
      setState(() {
        note.noteLabel = label;
        hasChanges = true;
      });
    } else {
      if (mounted) showSnackBar(context, response['error']);
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
    isSmallDevice = getScreenSize(context) == ScreenSize.small;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        if (formDirty && noteTextController.text.isNotEmpty) {
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
          title: GestureDetector(
            onTap: () => showTitleEditor(),
            child: Text(note.noteTitle),
          ),
          actions: [
            if (!editing)
              IconButton(
                onPressed: () => setState(() {
                  editing = true;
                }),
                tooltip: 'edit'.tr(),
                icon: Icon(Symbols.edit),
              ),
          ],
        ),
        body: editing
            ? Padding(
                padding: kPaddingLarge,
                child: TextField(
                  controller: noteTextController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'write_something'.tr(),
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
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 5,
                    color: NoteColor.getColor(note.noteColor, false),
                  ),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 600),
                      child: Padding(
                        padding: kPaddingLarge,
                        child: Markdown(
                          padding: EdgeInsets.zero,
                          data: note.noteText,
                          selectable: true,
                          softLineBreak: true,
                          onTapLink: (text, href, title) => _urlLauncher(href!),
                          styleSheet: MarkdownStyleSheet(
                            h1: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            h2: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            h3: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            checkbox: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: ScrawlLabelChip(label: note.noteLabel),
                  )
                ],
              ),
        bottomNavigationBar: editing
            ? Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: BottomAppBar(
                  padding: EdgeInsets.all(4),
                  child: MarkdownToolbar(
                    controller: noteTextController,
                    undoController: undoHistoryController,
                    onChange: () {},
                  ),
                ),
              )
            : Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: BottomAppBar(
                  padding: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      if (!editing)
                        IconButton(
                          onPressed: () => updateFavorite(),
                          tooltip: 'favorite'.tr(),
                          icon: Icon(
                            Symbols.favorite,
                            fill: note.noteFavorite ? 1 : 0,
                            color:
                                note.noteFavorite ? Colors.red.shade200 : null,
                          ),
                        ),
                      if (!editing)
                        IconButton(
                          onPressed: () => openColorPicker(),
                          tooltip: 'colors'.tr(),
                          icon: Icon(Symbols.palette),
                        ),
                      if (!editing)
                        IconButton(
                          onPressed: () => openLabels(note.noteLabel),
                          tooltip: 'labels'.tr(),
                          icon: Icon(Symbols.folder_open),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void showTitleEditor() async {
    noteTitleController.text = note.noteTitle;
    titleFocusNode.requestFocus();
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
                        'edit_title'.tr(),
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
                    focusNode: titleFocusNode,
                    maxLength: 30,
                    onTap: () => noteTitleController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: noteTitleController.value.text.length),
                    decoration: InputDecoration(
                      hintText: 'enter_title'.tr(),
                      counterText: '',
                    ),
                  ),
                  kVSpace,
                  FilledButton(
                    onPressed: () => saveTitle(),
                    child: Text('save'.tr()),
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
      if (noteTitleController.text.isNotEmpty) {
        note.noteTitle = noteTitleController.text;
        formDirty = true;
      }
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

  void openLabels(String labels) async {
    final label = (isSmallDevice && mounted)
        ? await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LabelsPage(
                      selectedLabels: labels,
                      assignMode: true,
                    )))
        : (mounted
            ? await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Dialog(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 500),
                      child: LabelsPage(
                        selectedLabels: labels,
                        assignMode: true,
                      ),
                    ),
                  );
                })
            : null);

    if (label != null) {
      updateLabel(label);
    }
  }

  Future<void> _urlLauncher(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
