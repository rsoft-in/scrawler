import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:scrawler/src/helpers/constants.dart';

class MarkdownToolbar extends StatefulWidget {
  final TextEditingController controller;
  final UndoHistoryController undoController;
  final VoidCallback onChange;
  const MarkdownToolbar(
      {super.key,
      required this.controller,
      required this.undoController,
      required this.onChange});

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
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ValueListenableBuilder<UndoHistoryValue>(
              valueListenable: widget.undoController,
              builder: (context, value, child) {
                return FButton.icon(
                  onPress: () => widget.undoController.undo(),
                  style: FButtonStyle.ghost(),
                  child: const Icon(FIcons.undo2),
                );
              }),
          ValueListenableBuilder<UndoHistoryValue>(
              valueListenable: widget.undoController,
              builder: (context, value, child) {
                return FButton.icon(
                  onPress: () => widget.undoController.redo(),
                  style: FButtonStyle.ghost(),
                  child: const Icon(FIcons.redo2),
                );
              }),
          const VerticalDivider(),
          FButton.icon(
            onPress: () => formatText('bold'),
            style: FButtonStyle.ghost(),
            child: const Icon(FIcons.bold),
          ),
          FButton.icon(
            onPress: () => formatText('italic'),
            style: FButtonStyle.ghost(),
            child: const Icon(FIcons.italic),
          ),
          FButton.icon(
            onPress: () => formatText('ul'),
            style: FButtonStyle.ghost(),
            child: const Icon(FIcons.list),
          ),
          FButton.icon(
            onPress: () => formatText('ol'),
            style: FButtonStyle.ghost(),
            child: const Icon(FIcons.listOrdered),
          ),
          FPopoverMenu(
            menuAnchor: Alignment.topRight,
            childAnchor: Alignment.bottomRight,
            menu: [
              FItemGroup(
                children: headingList
                    .map((h) => FItem(
                          title: Text(h['name'] ?? ''),
                          onPress: () => formatText(h['id'] ?? 'h1'),
                        ))
                    .toList(),
              )
            ],
            builder: (context, controller, child) => FButton.icon(
              onPress: controller.toggle,
              style: FButtonStyle.ghost(),
              child: Icon(FIcons.heading),
            ),
          ),
          FButton.icon(
            onPress: () => showLinkSheet(),
            style: FButtonStyle.ghost(),
            child: const Icon(FIcons.link),
          ),
        ],
      ),
    );
  }

  void formatText(String opt) {
    final selectedText =
        widget.controller.selection.textInside(widget.controller.text);
    final beforeText =
        widget.controller.selection.textBefore(widget.controller.text);
    final afterText =
        widget.controller.selection.textAfter(widget.controller.text);
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
      final selectedText =
          widget.controller.selection.textInside(widget.controller.text);
      setState(() {
        linkNameController.text = selectedText;
      });
    }

    showFSheet(
        context: context,
        useSafeArea: true,
        side: FLayout.btt,
        builder: (context) {
          return Container(
            padding: kGlobalOuterPadding * 2,
            color: context.theme.colors.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Insert Link',
                      style: TextStyle(fontSize: 18),
                    ),
                    FButton.icon(
                      onPress: () => Navigator.pop(context),
                      style: FButtonStyle.outline(),
                      child: Icon(FIcons.x),
                    ),
                  ],
                ),
                kVSpace,
                FTextField(
                  autofocus: true,
                  controller: linkNameController,
                  label: Text('Enter Link Name'),
                ),
                kVSpace,
                FTextField(
                  controller: linkUrlController,
                  hint: 'https://',
                  label: Text('Enter URL Address'),
                ),
                kVSpace,
                FButton(
                  onPress: () {
                    formatText('link');
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
                kVSpace,
              ],
            ),
          );
        });
  }
}
