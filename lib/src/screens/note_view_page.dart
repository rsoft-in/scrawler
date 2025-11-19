import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:forui/forui.dart';
import 'package:http/io_client.dart' as http;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/notes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/adaptive.dart';
import '../helpers/constants.dart';
import '../helpers/utility.dart';
import '../widgets/markdown_toolbar.dart';
import '../widgets/rs_toast.dart';

class NoteView extends StatefulWidget {
  final String server;
  final String username;
  final String password;
  final http.IOClient? client;
  final Note? note;
  const NoteView(
      {super.key,
      required this.server,
      required this.username,
      required this.password,
      required this.client,
      this.note});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  bool editing = false;
  bool formDirty = false;
  bool hasChanges = false;
  bool isSmallDevice = false;

  String noteTitle = "";
  String noteContent = "";
  TextEditingController noteTextController = TextEditingController();
  TextEditingController noteTitleController = TextEditingController();
  UndoHistoryController undoHistoryController = UndoHistoryController();

  FocusNode titleFocusNode = FocusNode();

  late NextcloudClient ncClient;

  void _initNextcloud() async {
    ncClient = NextcloudClient(
      Uri.parse(widget.server),
      loginName: widget.username,
      password: widget.password,
      httpClient: widget.client,
    );
  }

  Future<void> saveNote() async {
    if (noteTitleController.text.trim().isEmpty) return;
    RSToast.show(context, message: 'Updating...');
    try {
      if (widget.note == null) {
        await ncClient.notes.createNote(
            category: '',
            title: noteTitleController.text.trim(),
            content: noteTextController.text.trim(),
            favorite: 0,
            modified: (DateTime.now().millisecondsSinceEpoch / 1000).round());
      } else {
        await ncClient.notes.updateNote(
            id: widget.note!.id,
            category: widget.note!.category,
            title: noteTitleController.text.trim(),
            content: noteTextController.text.trim(),
            favorite: (widget.note!.favorite) ? 1 : 0,
            modified: (DateTime.now().millisecondsSinceEpoch / 1000).round());
      }
      setState(() {
        hasChanges = true;
        formDirty = false;
        editing = false;
      });
    } catch (e) {
      if (mounted) {
        RSToast.show(context, message: 'Failed to update note: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initNextcloud();
    setState(() {
      if (widget.note == null) {
        editing = true;
        noteTitle = 'Untitled';
      }
      if (widget.note != null) {
        noteTextController.text = widget.note!.content;
        noteTitleController.text = widget.note!.title;
        noteTitle = widget.note!.title;
        noteContent = widget.note!.content;
      }
    });
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
      child: FScaffold(
        childPad: false,
        header: FHeader.nested(
          title: GestureDetector(
            onTap: () => showTitleEditor(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(noteTitle),
            ),
          ),
          prefixes: [
            FHeaderAction.back(onPress: () async {
              if (formDirty) await saveNote();
              if (context.mounted) Navigator.pop(context, hasChanges);
            }),
          ],
          titleAlignment: Alignment.centerLeft,
          suffixes: [
            if (!editing)
              FButton.icon(
                onPress: () => setState(() {
                  editing = true;
                }),
                child: Icon(CupertinoIcons.pencil),
              ),
          ],
        ),
        footer: editing
            ? Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 20, left: 16, right: 16),
                child: MarkdownToolbar(
                  controller: noteTextController,
                  undoController: undoHistoryController,
                  onChange: () {},
                ),
              )
            : null,
        child: editing
            ? Container(
                margin: EdgeInsets.only(bottom: 8),
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: noteTextController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: 'write_something'.tr(),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        // filled: false,
                      ),
                      onChanged: (value) {
                        setState(() {
                          formDirty = true;
                        });
                      },
                    ),
                  ),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 600),
                            child: Markdown(
                              padding: EdgeInsets.zero,
                              data: noteContent,
                              selectable: true,
                              softLineBreak: true,
                              onTapLink: (text, href, title) =>
                                  _urlLauncher(href!),
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
                                horizontalRuleDecoration: BoxDecoration(
                                    border: Border.all(width: 0.1)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
      ),
    );
  }

  void showTitleEditor() async {
    noteTitleController.text = noteTitle;
    titleFocusNode.requestFocus();
    showFDialog(
      context: context,
      barrierDismissible: false,
      builder: (context, style, animation) {
        return FDialog.adaptive(
          actions: [
            FButton(
              onPress: () => saveTitle(),
              child: Text('save'.tr()),
            ),
            FButton(
              onPress: () => Navigator.pop(context),
              style: FButtonStyle.outline(),
              child: Text('cancel'.tr()),
            ),
          ],
          title: Text('edit_title'.tr()),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              kVSpace,
              FTextField(
                controller: noteTitleController,
                focusNode: titleFocusNode,
                maxLength: 30,
                onTap: () => noteTitleController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: noteTitleController.value.text.length),
                hint: 'enter_title'.tr(),
              ),
              kVSpace,
            ],
          ),
        );
      },
    );
  }

  void saveTitle() {
    setState(() {
      if (noteTitleController.text.trim().isNotEmpty) {
        formDirty = true;
        noteTitle = noteTitleController.text.trim();
      }
    });
    Navigator.pop(context);
  }

  Future<void> _urlLauncher(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
