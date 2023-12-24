import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:material_symbols_icons/symbols.dart';

class DesktopEditorToolbar extends StatefulWidget {
  final QuillController controller;
  const DesktopEditorToolbar({Key? key, required this.controller})
      : super(key: key);

  @override
  State<DesktopEditorToolbar> createState() => _DesktopEditorToolbarState();
}

class _DesktopEditorToolbarState extends State<DesktopEditorToolbar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          children: [
            QuillToolbarHistoryButton(
              isUndo: true,
              controller: widget.controller,
              options: const QuillToolbarHistoryButtonOptions(
                  iconData: Symbols.undo),
            ),
            QuillToolbarHistoryButton(
              isUndo: false,
              controller: widget.controller,
              options: const QuillToolbarHistoryButtonOptions(
                  iconData: Symbols.redo),
            ),
            const VerticalDivider(),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(
                  iconData: Symbols.format_bold),
              controller: widget.controller,
              attribute: Attribute.bold,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(
                  iconData: Symbols.format_italic),
              controller: widget.controller,
              attribute: Attribute.italic,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(
                  iconData: Symbols.format_underlined),
              controller: widget.controller,
              attribute: Attribute.underline,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(
                  iconData: Symbols.strikethrough_s),
              controller: widget.controller,
              attribute: Attribute.strikeThrough,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(
                  iconData: Symbols.subscript),
              controller: widget.controller,
              attribute: Attribute.subscript,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(
                  iconData: Symbols.superscript),
              controller: widget.controller,
              attribute: Attribute.superscript,
            ),
            QuillToolbarClearFormatButton(
              options: const QuillToolbarClearFormatButtonOptions(
                  iconData: Symbols.format_clear),
              controller: widget.controller,
            ),
            const VerticalDivider(),
            QuillToolbarColorButton(
              options: const QuillToolbarColorButtonOptions(
                  iconData: Symbols.palette),
              controller: widget.controller,
              isBackground: false,
            ),
            QuillToolbarColorButton(
              options: const QuillToolbarColorButtonOptions(
                  iconData: Symbols.colors),
              controller: widget.controller,
              isBackground: true,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(
                  iconData: Symbols.format_list_numbered),
              controller: widget.controller,
              attribute: Attribute.ol,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(
                  iconData: Symbols.format_list_bulleted),
              controller: widget.controller,
              attribute: Attribute.ul,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(
                  iconData: Symbols.code),
              controller: widget.controller,
              attribute: Attribute.inlineCode,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(
                  iconData: Symbols.format_quote),
              controller: widget.controller,
              attribute: Attribute.blockQuote,
            ),
            QuillToolbarIndentButton(
              options: const QuillToolbarIndentButtonOptions(
                  iconData: Symbols.format_indent_increase),
              controller: widget.controller,
              isIncrease: true,
            ),
            QuillToolbarIndentButton(
              options: const QuillToolbarIndentButtonOptions(
                  iconData: Symbols.format_indent_decrease),
              controller: widget.controller,
              isIncrease: false,
            ),
            const VerticalDivider(),
            QuillToolbarLinkStyleButton(
                options: const QuillToolbarLinkStyleButtonOptions(
                    iconData: Symbols.link),
                controller: widget.controller),
          ],
        ),
      ),
    );
  }
}
