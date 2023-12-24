import 'dart:convert';

import 'package:bnotes/desktop_web/desktop_editor_toolbar.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/notes.dart';
import 'package:bnotes/widgets/scrawl_empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class DesktopNoteWidget extends StatefulWidget {
  final Notes note;
  const DesktopNoteWidget(this.note, {Key? key}) : super(key: key);

  @override
  State<DesktopNoteWidget> createState() => _DesktopNoteWidgetState();
}

class _DesktopNoteWidgetState extends State<DesktopNoteWidget> {
  ScreenSize _screenSize = ScreenSize.large;
  final QuillController _controller = QuillController.basic();

  List<dynamic> getDocument() {
    try {
      final json = jsonDecode(widget.note.noteText);
      return json;
    } catch (e) {
      return [
        {"insert": widget.note.noteText}
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = getScreenSize(context);
    if (widget.note.noteText.isNotEmpty) {
      _controller.document = Document.fromJson(getDocument());
    }
    return widget.note.noteId.isEmpty
        ? EmptyWidget(
            text: 'Select a Note to preview',
            width: MediaQuery.of(context).size.width * 0.4,
            asset: 'images/nothing_to_do.svg')
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              QuillToolbar(
                configurations: const QuillToolbarConfigurations(),
                child: DesktopEditorToolbar(controller: _controller),
              ),
              kVSpace,
              Expanded(
                child: Padding(
                  padding: kPaddingLarge,
                  child: SingleChildScrollView(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: _screenSize == ScreenSize.large
                            ? 800
                            : double.infinity,
                        child: QuillEditor.basic(
                          configurations: QuillEditorConfigurations(
                            controller: _controller,
                            readOnly: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
  }
}
