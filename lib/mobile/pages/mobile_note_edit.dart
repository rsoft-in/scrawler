import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/markdown_toolbar.dart';
import 'package:scrawler/mobile/dbhelper.dart';
import 'package:scrawler/models/notes.dart';
import 'package:scrawler/widgets/scrawl_color_dot.dart';
import 'package:scrawler/widgets/scrawl_color_picker.dart';
import 'package:uuid/uuid.dart';

class MobileNoteEdit extends StatefulWidget {
  final Notes note;
  final bool isNewNote;
  final bool readMode;
  const MobileNoteEdit(
      {super.key,
      required this.note,
      this.isNewNote = false,
      this.readMode = true});

  @override
  State<MobileNoteEdit> createState() => _MobileNoteEditState();
}

class _MobileNoteEditState extends State<MobileNoteEdit> {
  TextEditingController titleController = TextEditingController();
  TextEditingController editorController = TextEditingController();
  UndoHistoryController undoController = UndoHistoryController();
  DBHelper dbHelper = DBHelper();
  Notes currentNote = Notes.empty();
  bool readMode = true;
  bool hasChanges = false;
  bool formDirty = false;
  bool showToolbar = true;

  Future<void> saveNote() async {
    if (titleController.text.isEmpty) {
      titleController.text = 'Untitled';
    }
    if (editorController.text.isEmpty) {
      return;
    }
    bool result = false;
    if (widget.isNewNote) {
      var noteId = const Uuid().v1();
      currentNote = Notes(noteId, DateTime.now().toString(),
          titleController.text, editorController.text, '', false, 0, '', false);
      result = await dbHelper.insertNotes(currentNote);
    } else {
      currentNote.noteTitle = titleController.text;
      currentNote.noteText = editorController.text;
      currentNote.noteDate = DateTime.now().toString();
      result = await dbHelper.updateNotes(currentNote);
    }
    if (result) {
      setState(() {
        readMode = true;
        hasChanges = true;
        formDirty = false;
      });
    }
    if (!result && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to save changes'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> saveColor(int noteColor) async {
    final res = await dbHelper.updateNoteColor(currentNote.noteId, noteColor);
    if (res) {
      setState(() {
        currentNote.noteColor = noteColor;
        hasChanges = true;
      });
    } else {
      print('Unable to save note color!');
    }
  }

  @override
  void initState() {
    super.initState();
    readMode = widget.readMode;
    currentNote = widget.note;
    editorController.text = widget.note.noteText;
    titleController.text = widget.note.noteTitle;
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
          title: GestureDetector(
            onTap: () => readMode ? null : editTitle(),
            child: Text(currentNote.noteTitle),
          ),
          actions: [
            if (readMode) ScrawlColorDot(colorCode: widget.note.noteColor),
            if (currentNote.noteFavorite && readMode)
              const Icon(
                Symbols.favorite,
                color: Colors.red,
              ),
            if (!readMode)
              IconButton(
                tooltip: 'Show/Hide toolbar',
                onPressed: () {
                  setState(() {
                    showToolbar = !showToolbar;
                  });
                },
                icon: const Icon(Symbols.keyboard_arrow_down),
                selectedIcon: const Icon(Symbols.keyboard_arrow_up),
                isSelected: showToolbar,
              ),
            if (!readMode)
              IconButton.filledTonal(
                onPressed: () => saveNote(),
                icon: const Icon(Symbols.check),
              ),
            if (readMode)
              IconButton(
                onPressed: () {
                  setState(() {
                    readMode = false;
                  });
                },
                icon: const Icon(Symbols.edit),
              ),
            if (readMode)
              PopupMenuButton<int>(
                icon: const Icon(Symbols.more_vert),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 0,
                      child: ListTile(
                        leading: Icon(Symbols.palette),
                        title: Text('Change Color'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        leading: Icon(Symbols.label),
                        title: Text('Move to Folder'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: ListTile(
                        leading: Icon(Symbols.delete),
                        title: Text('Delete'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: ListTile(
                        leading: Icon(Symbols.favorite),
                        title: Text('Add to Favorites'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 4,
                      child: ListTile(
                        leading: Icon(Symbols.archive),
                        title: Text('Archive'),
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      changeColor();
                      break;
                    case 2:
                      // widget.onDeleteClicked();
                      break;
                    case 3:
                      // widget.onFavoriteClicked();
                      break;
                    default:
                  }
                },
              ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (!readMode && showToolbar)
              MarkdownToolbar(
                controller: editorController,
                undoController: undoController,
                onChange: () {},
              ),
            Expanded(
              child: Padding(
                padding: kPaddingLarge,
                child: readMode
                    ? Markdown(
                        padding: EdgeInsets.zero,
                        data: currentNote.noteText,
                        selectable: true,
                        softLineBreak: true,
                      )
                    : TextFormField(
                        controller: editorController,
                        maxLines: null,
                        expands: true,
                        autofocus: true,
                        style: const TextStyle(fontSize: 14.0),
                        decoration: const InputDecoration(
                          isCollapsed: true,
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
            if (!readMode)
              const Divider(
                height: 2,
                thickness: 0.2,
              ),
          ],
        ),
      ),
    );
  }

  void editTitle() async {
    final result = await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: kPaddingLarge * 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit Title',
                style: TextStyle(fontSize: 22),
              ),
              kVSpace,
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter title here',
                ),
              ),
              kVSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  kHSpace,
                  FilledButton.tonal(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Ok'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (result) {
      setState(() {
        currentNote.noteTitle = titleController.text;
        formDirty = true;
      });
    }
  }

  void changeColor() async {
    final colorCode = await showDialog(
        context: context,
        builder: (context) {
          return const ScrawlColorPicker();
        });
    if (colorCode != null) {
      saveColor(colorCode);
    }
  }
}
