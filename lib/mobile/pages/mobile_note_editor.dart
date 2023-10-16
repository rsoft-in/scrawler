import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:yaru_icons/yaru_icons.dart';

import '../../helpers/constants.dart';
import '../../helpers/dbhelper.dart';
import '../../helpers/enums.dart';
import '../../helpers/globals.dart' as globals;
import '../../helpers/language.dart';
import '../../models/notes.dart';
import '../../widgets/scrawl_appbar.dart';
import '../../widgets/scrawl_color_dot.dart';
import '../../widgets/scrawl_color_picker.dart';
import '../../widgets/scrawl_label_chip.dart';
import '../../widgets/scrawl_snackbar.dart';
import 'mobile_labels_page.dart';

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
  bool noteUpdated = false;
  bool darkModeOn = false;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  Notes note = Notes.empty();
  final dbHelper = DBHelper.instance;

  TextEditingController noteTitleController = TextEditingController();
  TextEditingController noteTextController = TextEditingController();
  UndoHistoryController undoHistoryController = UndoHistoryController();
  TextEditingController linkDescController = TextEditingController();
  TextEditingController linkController = TextEditingController();

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
      noteTextController.text = note.noteText;
      noteTitleController.text = note.noteTitle;
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
          child: ScrawlAppBar(
            middle: isEditMode
                ? TextField(
                    controller: noteTitleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter title here',
                    ),
                    onEditingComplete: () => setState(() {
                      note.noteTitle = noteTitleController.text;
                    }),
                  )
                : Text(
                    note.noteTitle,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
            onPressed: () {
              saveNote();
              Navigator.pop(context, true);
            },
            trailing: ScrawlColorDot(colorCode: note.noteColor),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: isEditMode
                  ? TextField(
                      scrollController: _scrollViewController,
                      controller: noteTextController,
                      undoController: undoHistoryController,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (note.noteLabel.isNotEmpty)
                              SizedBox(
                                height: 40,
                                child: ScrawlLabelChip(label: note.noteLabel),
                              ),
                            MarkdownBody(
                                selectable: true,
                                softLineBreak: true,
                                onTapLink: (text, href, title) =>
                                    _launchUrl(href),
                                styleSheet: MarkdownStyleSheet(
                                    blockquote:
                                        const TextStyle(color: Colors.black),
                                    blockquoteDecoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border(
                                        left: BorderSide(
                                            color: kPrimaryColor, width: 3),
                                      ),
                                    ),
                                    code: const TextStyle(
                                        backgroundColor: Colors.transparent),
                                    codeblockAlign: WrapAlignment.spaceAround,
                                    codeblockDecoration: BoxDecoration(
                                        color: darkModeOn
                                            ? Colors.white10
                                            : Colors.black12),
                                    checkbox: TextStyle(
                                        color: darkModeOn
                                            ? kLightPrimary
                                            : kDarkPrimary)),
                                data: note.noteText),
                          ],
                        ),
                      ),
                    ),
            ),
            if (isEditMode)
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  onTap: () =>
                                      onToolbarClick(EditorTools.h1, true),
                                  child: const Text('Heading 1'),
                                ),
                                PopupMenuItem(
                                  value: 'h2',
                                  onTap: () =>
                                      onToolbarClick(EditorTools.h2, true),
                                  child: const Text('Heading 2'),
                                ),
                                PopupMenuItem(
                                  value: 'h3',
                                  onTap: () =>
                                      onToolbarClick(EditorTools.h3, true),
                                  child: const Text('Heading 3'),
                                ),
                                PopupMenuItem(
                                  value: 'h4',
                                  onTap: () =>
                                      onToolbarClick(EditorTools.h4, true),
                                  child: const Text('Heading 4'),
                                ),
                              ]),
                      IconButton(
                        onPressed: () => onToolbarClick(EditorTools.bold, true),
                        icon: const Icon(
                          YaruIcons.bold,
                          size: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            onToolbarClick(EditorTools.italic, true),
                        icon: const Icon(
                          YaruIcons.italic,
                          size: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            onToolbarClick(EditorTools.link, false),
                        icon: const Icon(
                          YaruIcons.insert_link,
                          size: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            onToolbarClick(EditorTools.image, false),
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
                      ValueListenableBuilder<UndoHistoryValue>(
                        valueListenable: undoHistoryController,
                        builder: (context, value, child) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: value.canUndo
                                    ? () {
                                        undoHistoryController.undo();
                                      }
                                    : null,
                                icon: const Icon(YaruIcons.undo),
                              ),
                              IconButton(
                                onPressed: value.canRedo
                                    ? () {
                                        undoHistoryController.redo();
                                      }
                                    : null,
                                icon: const Icon(YaruIcons.redo),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: isEditMode
            ? null
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
                        onPressed: () => confirmDelete(note),
                        icon: const Icon(YaruIcons.trash),
                      ),
                      IconButton(
                        onPressed: () => pickColor(note),
                        icon: const Icon(YaruIcons.colors),
                      ),
                      IconButton(
                        onPressed: () => selectTag(note),
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
    // Note: if the reader is closed without any changes,
    // it would still save the note updating its modified time.
    final res = await saveNote();
    if (context.mounted) {
      if (res) {
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context, noteUpdated);
      }
    }
    return false;
  }

  void confirmDelete(Notes note) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              FilledButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, 'delete');
                },
              ),
              OutlinedButton(
                child: const Text('No'),
                onPressed: () => Navigator.pop(context),
              )
            ],
            title: const Text('Confirm'),
            content: const Text('Are you sure you want to delete?'),
          );
        });
  }

  void pickColor(Notes note) async {
    final colorCode = await showDialog(
        context: context,
        builder: (context) {
          return const ScrawlColorPicker();
        });
    if (colorCode != null) {
      note.noteColor = colorCode;
      noteUpdated = true;
      setState(() {});
      updateNoteColor(note, colorCode);
    }
  }

  void selectTag(Notes note) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MobileLabelsPage(preselect: note.noteLabel)));
    if (result != null) {
      note.noteLabel = result;
      noteUpdated = true;
      setState(() {});
      updateNoteLabel(note, result);
    }
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

  Future<void> onToolbarClick(EditorTools tool, bool needSelection) async {
    if (!noteTextController.selection.isValid) {
      return;
    }
    var startIndex = noteTextController.selection.baseOffset;
    var endIndex = noteTextController.selection.extentOffset;
    var selectedText =
        noteTextController.selection.textInside(noteTextController.text);
    var textBefore = noteTextController.text.substring(0, startIndex);
    var textAfter = noteTextController.text.substring(endIndex);

    if (selectedText.isEmpty && needSelection) return;
    switch (tool) {
      case EditorTools.h1:
      case EditorTools.h2:
      case EditorTools.h3:
      case EditorTools.h4:
        noteTextController.text =
            '$textBefore${getHeaderElement(tool)} $selectedText $textAfter';
        break;
      case EditorTools.bold:
        noteTextController.text = '$textBefore**$selectedText**$textAfter';
        break;
      case EditorTools.italic:
        noteTextController.text = '${textBefore}_${selectedText}_$textAfter';
        break;
      case EditorTools.link:
      case EditorTools.image:
        var linkCode = await addLink(tool);
        noteTextController.text = '$textBefore$linkCode$textAfter';
        break;
      default:
        break;
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

  Future<String> addLink(EditorTools tool) async {
    final result = await showDialog(
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
                      'Add a Link or Image',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
                    ),
                  ),
                  kVSpace,
                  TextField(
                    controller: linkDescController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Description',
                    ),
                  ),
                  kVSpace,
                  TextField(
                    controller: linkController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Link',
                    ),
                  ),
                  kVSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Ok'),
                      ),
                      kHSpace,
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
    if (result) {
      if (tool == EditorTools.link) {
        return '[${linkDescController.text}](${linkController.text})';
      } else {
        return '![${linkDescController.text}](${linkController.text})';
      }
    } else {
      return '';
    }
  }

  Future<bool> saveNote() async {
    note.noteDate = DateTime.now().toIso8601String();
    note.noteText = noteTextController.text;
    note.noteTitle = noteTitleController.text;
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

  void updateNoteColor(Notes note, int colorCode) async {
    final result = await dbHelper.updateNoteColor(note.noteId, colorCode);
    if (!result) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(ScrawlSnackBar.show(context, 'Failed to update!'));
      }
    }
  }

  void updateNoteLabel(Notes note, String label) async {
    final result = await dbHelper.updateNoteLabel(note.noteId, label);
    if (!result) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(ScrawlSnackBar.show(context, 'Failed to update!'));
      }
    }
  }
}
