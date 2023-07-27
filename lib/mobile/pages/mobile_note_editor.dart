import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/enums.dart';
import 'package:bnotes/helpers/language.dart';
import 'package:bnotes/models/notes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yaru_icons/yaru_icons.dart';

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

  TextEditingController noteTextController = TextEditingController();
  TextEditingController noteTitleController = TextEditingController();

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: AnimatedContainer(
            height: _showAppbar ? 56.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: AppBar(
                leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
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
}
