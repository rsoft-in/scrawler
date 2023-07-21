import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/language.dart';
import 'package:bnotes/models/notes.dart';
import 'package:bnotes/widgets/scrawl_button_filled.dart';
import 'package:bnotes/widgets/scrawl_button_outlined.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: AnimatedContainer(
            height: _showAppbar ? 56.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: AppBar(
                leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Iconsax.arrow_left_2)),
                title: GestureDetector(
                  onTap: () => titleDialog(),
                  child: Row(
                    children: [
                      Text(note.noteTitle),
                      kHSpace,
                      const Icon(
                        Iconsax.edit,
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
                child: Text('Ok'),
                onPressed: () => setState(() {
                  note.noteTitle = noteTitleController.text;
                  Navigator.pop(context);
                }),
              ),
              OutlinedButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }
}
