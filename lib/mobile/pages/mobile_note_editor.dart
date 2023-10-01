import 'package:bnotes/widgets/scrawl_appbar.dart';
import 'package:bnotes/widgets/scrawl_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:yaru_icons/yaru_icons.dart';

import '../../helpers/constants.dart';
import '../../helpers/dbhelper.dart';
import '../../helpers/enums.dart';
import '../../helpers/language.dart';
import '../../models/notes.dart';
import '../../helpers/globals.dart' as globals;

class MobileNoteEditor extends StatefulWidget {
  final Notes note;
  final bool? editMode;

  const MobileNoteEditor({Key? key, required this.note, this.editMode = false})
      : super(key: key);

  @override
  State<MobileNoteEditor> createState() => _MobileNoteEditorState();
}

class _MobileNoteEditorState extends State<MobileNoteEditor> {
  late ScrollController _scrollViewController;
  bool isEditMode = false;
  bool darkModeOn = false;
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
      isEditMode = widget.editMode ?? false;
      noteTextController.text = widget.note.noteText;
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
    var brightness = MediaQuery.of(context).platformBrightness;
    darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (globals.themeMode == ThemeMode.system &&
            brightness == Brightness.dark));

    return WillPopScope(
      onWillPop: isEditMode ? onBackPressed : null,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(84),
          child: SafeArea(
            child: ScrawlAppBar(
              title: widget.note.noteTitle,
              onPressed: () {
                saveNote();
                Navigator.pop(context, true);
              },
              titleEdit: isEditMode
                  ? GestureDetector(
                      onTap: () => titleDialog(),
                      child: const Icon(
                        YaruIcons.pen,
                        size: 18,
                      ),
                    )
                  : null,
            ),
          ),
        ),
        body: isEditMode
            ? TextField(
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
              )
            : Container(
                padding: kPaddingLarge,
                child: SingleChildScrollView(
                  controller: _scrollViewController,
                  child: MarkdownBody(
                      selectable: true,
                      softLineBreak: true,
                      onTapLink: (text, href, title) => _launchUrl(href),
                      styleSheet: MarkdownStyleSheet(
                          blockquote: const TextStyle(color: Colors.black),
                          blockquoteDecoration: const BoxDecoration(
                            color: Colors.transparent,
                            border: Border(
                              left: BorderSide(color: kPrimaryColor, width: 3),
                            ),
                          ),
                          code: const TextStyle(
                              backgroundColor: Colors.transparent),
                          codeblockAlign: WrapAlignment.spaceAround,
                          codeblockDecoration: BoxDecoration(
                              color:
                                  darkModeOn ? Colors.white10 : Colors.black12),
                          checkbox: TextStyle(
                              color:
                                  darkModeOn ? kLightPrimary : kDarkPrimary)),
                      data: widget.note.noteText),
                ),
              ),
        bottomNavigationBar: isEditMode
            ? BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PopupMenuButton(
                        icon: const Text(
                          'H',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'h1',
                                onTap: () => onToolbarClick(EditorTools.h1),
                                child: const Text('Heading 1'),
                              ),
                              PopupMenuItem(
                                value: 'h2',
                                onTap: () => onToolbarClick(EditorTools.h2),
                                child: const Text('Heading 2'),
                              ),
                              PopupMenuItem(
                                value: 'h3',
                                onTap: () => onToolbarClick(EditorTools.h3),
                                child: const Text('Heading 3'),
                              ),
                              PopupMenuItem(
                                value: 'h4',
                                onTap: () => onToolbarClick(EditorTools.h4),
                                child: const Text('Heading 4'),
                              ),
                            ]),
                    IconButton(
                      onPressed: () => onToolbarClick(EditorTools.bold),
                      icon: const Icon(
                        YaruIcons.bold,
                        size: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () => onToolbarClick(EditorTools.italic),
                      icon: const Icon(
                        YaruIcons.italic,
                        size: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () => addLink(),
                      icon: const Icon(
                        YaruIcons.insert_link,
                        size: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () => addImage(),
                      icon: const Icon(
                        YaruIcons.image,
                        size: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        YaruIcons.unordered_list,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              )
            : AnimatedContainer(
                height: _showAppbar ? 80.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => setState(() {
                          isEditMode = true;
                        }),
                        icon: const Icon(YaruIcons.pen),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context, 'delete'),
                        icon: const Icon(YaruIcons.trash),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(YaruIcons.colors),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(YaruIcons.tag),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Future<bool> onBackPressed() async {
    final res = await saveNote();
    if (context.mounted) {
      if (res) {
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context, false);
      }
    }
    return false;
  }

  void titleDialog() {
    setState(() {
      noteTitleController.text = note.noteTitle;
    });
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit'),
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
    if (!noteTextController.selection.isValid) {
      return;
    }
    var selectedText =
        noteTextController.selection.textInside(noteTextController.text);
    var startIndex = noteTextController.selection.baseOffset;
    var endIndex = noteTextController.selection.extentOffset;
    if (selectedText.isEmpty) return;
    switch (tool) {
      case EditorTools.h1:
      case EditorTools.h2:
      case EditorTools.h3:
      case EditorTools.h4:
        noteTextController.text =
            '${noteTextController.text.substring(0, startIndex)}${getHeaderElement(tool)} $selectedText ${noteTextController.text.substring(endIndex)}';
        break;
      case EditorTools.bold:
        noteTextController.text =
            '${noteTextController.text.substring(0, startIndex)}**$selectedText**${noteTextController.text.substring(endIndex)}';
        break;
      case EditorTools.italic:
        noteTextController.text =
            '${noteTextController.text.substring(0, startIndex)}_${selectedText}_${noteTextController.text.substring(endIndex)}';
        break;

      default:
    }
    setState(() {});
  }

  String getHeaderElement(EditorTools tool) {
    switch (tool) {
      case EditorTools.h1:
        return '#';
      case EditorTools.h2:
        return '##';
      case EditorTools.h3:
        return '###';
      case EditorTools.h4:
        return '####';
      default:
        return '#';
    }
  }

  void addLink() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: kPaddingLarge,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Add a link',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
                    ),
                  ),
                  kVSpace,
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Description',
                    ),
                  ),
                  kVSpace,
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Link',
                    ),
                  ),
                  kVSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        onPressed: () {},
                        child: const Text('Ok'),
                      ),
                      kHSpace,
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void addImage() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: kPaddingLarge,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Add an Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                  kVSpace,
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Description',
                    ),
                  ),
                  kVSpace,
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Image Link',
                    ),
                  ),
                  kVSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        onPressed: () {},
                        child: const Text('Ok'),
                      ),
                      kHSpace,
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<bool> saveNote() async {
    note.noteDate = DateTime.now().toIso8601String();
    note.noteText = noteTextController.text;
    if (note.noteText.isEmpty) {
      return false;
    }
    bool result = false;
    if (note.noteId.isEmpty) {
      var uid = const Uuid();
      note.noteId = uid.v1();
      result = await dbHelper.insertNotes(note);
    } else {
      result = await dbHelper.updateNotes(note);
    }
    if (!result) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(ScrawlSnackBar.show(context, 'Failed to save!'));
      }
    }
    return result;
  }
}
