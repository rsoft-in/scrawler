import 'package:bnotes/widgets/scrawl_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';
import 'package:yaru_icons/yaru_icons.dart';

import '../../helpers/constants.dart';
import '../../helpers/dbhelper.dart';
import '../../helpers/enums.dart';
import '../../helpers/language.dart';
import '../../models/notes.dart';

class MobileNoteEditor extends StatefulWidget {
  final Notes note;

  const MobileNoteEditor({Key? key, required this.note}) : super(key: key);

  @override
  State<MobileNoteEditor> createState() => _MobileNoteEditorState();
}

class _MobileNoteEditorState extends State<MobileNoteEditor> {
  late ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  Notes note = Notes.empty();
  final dbHelper = DBHelper.instance;

  TextEditingController noteTextController = TextEditingController();
  TextEditingController noteTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
    setState(() {
      note = widget.note;
    });
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final res = await saveNote();
        return res;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: SafeArea(
            child: AnimatedContainer(
              height: _showAppbar ? 56.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: AppBar(
                  leading: GestureDetector(
                      onTap: () async {
                        final res = await saveNote();
                        if (res) {
                          Navigator.pop(context, true);
                        } else {
                          Navigator.pop(context, false);
                        }
                      },
                      child: const Icon(YaruIcons.pan_start)),
                  title: GestureDetector(
                    onTap: () => titleDialog(),
                    child: Row(
                      children: [
                        Text(note.noteTitle),
                        kHSpace,
                        const Icon(
                          YaruIcons.pen,
                          size: 18,
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TextField(
                scrollController: _scrollViewController,
                controller: noteTextController,
                decoration: InputDecoration(
                    hintText: Language.get('type_something'),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
                textAlignVertical: TextAlignVertical.top,
                expands: true,
                maxLines: null,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => onToolbarClick(EditorTools.bold),
                  icon: const Text(
                    'H',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => onToolbarClick(EditorTools.bold),
                  icon: const Icon(YaruIcons.bold),
                ),
                IconButton(
                  onPressed: () => onToolbarClick(EditorTools.italic),
                  icon: const Icon(YaruIcons.italic),
                ),
                IconButton(
                  onPressed: () => onToolbarClick(EditorTools.underline),
                  icon: const Icon(YaruIcons.underline),
                ),
                IconButton(
                  onPressed: () => onToolbarClick(EditorTools.link),
                  icon: const Icon(YaruIcons.insert_link),
                ),
                IconButton(
                  onPressed: () => onToolbarClick(EditorTools.image),
                  icon: const Icon(YaruIcons.image),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(YaruIcons.view_more),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void titleDialog() {
    setState(() {
      noteTitleController.text = note.noteTitle;
    });
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: noteTitleController,
              decoration: const InputDecoration(
                hintText: 'Enter title here',
              ),
            ),
            actions: [
              FilledButton(
                child: const Text('Ok'),
                onPressed: () => setState(() {
                  note.noteTitle = noteTitleController.text;
                  Navigator.pop(context);
                }),
              ),
              OutlinedButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  void onToolbarClick(EditorTools tool) {
    var selectedText =
        noteTextController.selection.textInside(noteTextController.text);
    var startIndex = noteTextController.selection.baseOffset;
    var endIndex = noteTextController.selection.extentOffset;
    switch (tool) {
      case EditorTools.bold:
        noteTextController.text =
            '${noteTextController.text.substring(0, startIndex)}**$selectedText**${noteTextController.text.substring(endIndex)}';
        break;
      case EditorTools.italic:
        noteTextController.text =
            '${noteTextController.text.substring(0, startIndex)}__${selectedText}__${noteTextController.text.substring(endIndex)}';
        break;

      default:
    }
    setState(() {});
  }

  Future<bool> saveNote() async {
    if (note.noteTitle.toLowerCase() == 'untitled' && note.noteText.isEmpty) {
      return false;
    }
    if (note.noteId.isEmpty) {
      var uid = const Uuid();
      note.noteId = uid.v1();
      note.noteDate = DateTime.now().toIso8601String();
      note.noteText = noteTextController.text;
      final result = await dbHelper.insertNotes(note);
      print(result);
      if (!result) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(ScrawlSnackBar.show(context, 'Failed to save!'));
        }
      }
      return result;
    }
    return false;
  }
}
