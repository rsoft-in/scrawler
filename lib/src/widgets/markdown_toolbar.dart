import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:scrawler/src/helpers/constants.dart';

class MarkdownToolbar extends StatefulWidget {
  final TextEditingController controller;
  final UndoHistoryController undoController;
  final VoidCallback onChange;
  const MarkdownToolbar({
    super.key,
    required this.controller,
    required this.undoController,
    required this.onChange,
  });

  @override
  State<MarkdownToolbar> createState() => _MarkdownToolbarState();
}

class _MarkdownToolbarState extends State<MarkdownToolbar> {
  // TextEditingController imgDescController = TextEditingController();
  // TextEditingController imgUrlController = TextEditingController();
  String imgName = "";
  String imgUrl = "";
  TextEditingController linkNameController = TextEditingController();
  TextEditingController linkUrlController = TextEditingController();
  List<Map<String, String>> headingList = [
    {'id': 'h1', 'name': '${'heading'.tr()} 1'},
    {'id': 'h2', 'name': '${'heading'.tr()} 2'},
    {'id': 'h3', 'name': '${'heading'.tr()} 3'},
    {'id': 'h4', 'name': '${'heading'.tr()} 4'},
    {'id': 'h5', 'name': '${'heading'.tr()} 5'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ValueListenableBuilder<UndoHistoryValue>(
              valueListenable: widget.undoController,
              builder: (context, value, child) {
                return IconButton(
                  onPressed: () => widget.undoController.undo(),
                  // variant: FButtonVariant.ghost,
                  icon: const Icon(Symbols.undo),
                );
              },
            ),
            ValueListenableBuilder<UndoHistoryValue>(
              valueListenable: widget.undoController,
              builder: (context, value, child) {
                return IconButton(
                  onPressed: () => widget.undoController.redo(),
                  icon: const Icon(Symbols.redo),
                );
              },
            ),
            const VerticalDivider(color: Colors.grey),
            IconButton(
              onPressed: () => formatText('bold'),
              icon: const Icon(Symbols.format_bold),
            ),
            IconButton(
              onPressed: () => formatText('italic'),
              icon: const Icon(Symbols.format_italic),
            ),
            IconButton(
              onPressed: () => formatText('ul'),
              icon: const Icon(Symbols.format_list_bulleted),
            ),
            IconButton(
              onPressed: () => formatText('ol'),
              icon: const Icon(Symbols.format_list_numbered),
            ),
            PopupMenuButton(
              itemBuilder: (context) => headingList
                  .map(
                    (h) => PopupMenuItem(
                      child: Text(h['name'] ?? ''),
                      onTap: () => formatText(h['id'] ?? 'h1'),
                    ),
                  )
                  .toList(),

              icon: Icon(Symbols.text_format),
            ),
            IconButton(
              onPressed: () => showLinkSheet(),
              icon: const Icon(Symbols.link),
            ),
          ],
        ),
      ),
    );
  }

  void formatText(String opt) {
    final selectedText = widget.controller.selection.textInside(
      widget.controller.text,
    );
    final beforeText = widget.controller.selection.textBefore(
      widget.controller.text,
    );
    final afterText = widget.controller.selection.textAfter(
      widget.controller.text,
    );
    setState(() {
      if (selectedText.isNotEmpty || imgUrl.isNotEmpty) {
        switch (opt) {
          case 'bold':
            widget.controller.text = '$beforeText**$selectedText**$afterText';
            break;
          case 'italic':
            widget.controller.text = '$beforeText*$selectedText*$afterText';
            break;
          case 'h1':
          case 'h2':
          case 'h3':
          case 'h4':
          case 'h5':
          case 'h6':
            int seq = int.parse(opt.substring(1));
            widget.controller.text =
                '$beforeText${'#' * seq} $selectedText$afterText';
            break;
          case 'ul':
          case 'ol':
            final ol = selectedText.split('\n');
            String lText = "";
            for (int i = 0; i < ol.length; i++) {
              if (ol[i].trim().isNotEmpty) {
                lText += "${opt == 'ul' ? '-' : '${i + 1}.'} ${ol[i]}\n";
              }
            }
            widget.controller.text = '$beforeText\n$lText\n$afterText';
            break;
          case 'image':
            widget.controller.text =
                '$beforeText![$imgName]($imgUrl)$afterText';
            imgName = "";
            imgUrl = "";
            break;
          case 'link':
            widget.controller.text =
                '$beforeText[${linkNameController.text}](${linkUrlController.text})$afterText';
            linkNameController.text = "";
            linkUrlController.text = "";
            break;
          default:
        }
        widget.onChange();
      }
    });
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      imgUrl = file.path;
      imgName = "image";
      formatText('image');
    } else {
      // User canceled the picker
    }
  }

  void showLinkSheet() {
    if (widget.controller.selection.isValid) {
      final selectedText = widget.controller.selection.textInside(
        widget.controller.text,
      );
      setState(() {
        linkNameController.text = selectedText;
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: kGlobalOuterPadding * 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('insert_link'.tr(), style: TextStyle(fontSize: 18)),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Symbols.close),
                    ),
                  ],
                ),
                kVSpace,
                TextField(
                  autofocus: true,
                  controller: linkNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('enter_link_name'.tr()),
                  ),
                ),
                kVSpace,
                TextField(
                  controller: linkUrlController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hint: Text('https://'),
                    label: Text('enter_url'.tr()),
                  ),
                ),
                kVSpace,
                FilledButton(
                  onPressed: () {
                    formatText('link');
                    Navigator.pop(context);
                  },
                  child: Text('add'.tr()),
                ),
                kVSpace,
              ],
            ),
          ),
        );
      },
    );
  }
}
