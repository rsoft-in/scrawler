import 'dart:io';

import 'package:bnotes/helpers/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:universal_platform/universal_platform.dart';

class MarkdownToolbar extends StatefulWidget {
  final TextEditingController controller;
  const MarkdownToolbar({Key? key, required this.controller}) : super(key: key);

  @override
  State<MarkdownToolbar> createState() => _MarkdownToolbarState();
}

class _MarkdownToolbarState extends State<MarkdownToolbar> {
  TextEditingController imgDescController = TextEditingController();
  TextEditingController imgUrlController = TextEditingController();
  TextEditingController linkNameController = TextEditingController();
  TextEditingController linkUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          UniversalPlatform.isIOS
              ? CupertinoButton(
                  child: const Icon(CupertinoIcons.arrow_turn_up_left),
                  onPressed: () {})
              : IconButton(
                  onPressed: () {},
                  icon: const Icon(Symbols.undo),
                  tooltip: 'Undo',
                ),
          UniversalPlatform.isIOS
              ? CupertinoButton(
                  child: const Icon(CupertinoIcons.arrow_turn_up_right),
                  onPressed: () {})
              : IconButton(
                  onPressed: () {},
                  icon: const Icon(Symbols.redo),
                  tooltip: 'Redo',
                ),
          const VerticalDivider(),
          UniversalPlatform.isIOS
              ? CupertinoButton(
                  child: const Icon(CupertinoIcons.bold),
                  onPressed: () => formatText('bold'))
              : IconButton(
                  onPressed: () => formatText('bold'),
                  icon: const Icon(Symbols.format_bold),
                  tooltip: 'Bold',
                ),
          UniversalPlatform.isIOS
              ? CupertinoButton(
                  child: const Icon(CupertinoIcons.italic),
                  onPressed: () => formatText('italic'))
              : IconButton(
                  onPressed: () => formatText('italic'),
                  icon: const Icon(Symbols.format_italic),
                  tooltip: 'Italic',
                ),
          UniversalPlatform.isIOS
              ? CupertinoButton(
                  child: const Icon(CupertinoIcons.list_bullet),
                  onPressed: () => formatText('ul'))
              : IconButton(
                  onPressed: () => formatText('ul'),
                  icon: const Icon(Symbols.format_list_bulleted),
                  tooltip: 'Bulleted List',
                ),
          UniversalPlatform.isIOS
              ? CupertinoButton(
                  child: const Icon(CupertinoIcons.list_number),
                  onPressed: () => formatText('ol'))
              : IconButton(
                  onPressed: () => formatText('ol'),
                  icon: const Icon(Symbols.format_list_numbered),
                  tooltip: 'Numbered List',
                ),
          UniversalPlatform.isIOS
              ? CupertinoContextMenu(
                  actions: [
                      CupertinoContextMenuAction(
                        child: const Text('Heading 1'),
                        onPressed: () => formatText('h1'),
                      ),
                      CupertinoContextMenuAction(
                        child: const Text('Heading 2'),
                        onPressed: () => formatText('h2'),
                      ),
                      CupertinoContextMenuAction(
                        child: const Text('Heading 3'),
                        onPressed: () => formatText('h3'),
                      ),
                      CupertinoContextMenuAction(
                        child: const Text('Heading 4'),
                        onPressed: () => formatText('h4'),
                      ),
                      CupertinoContextMenuAction(
                        child: const Text('Heading 5'),
                        onPressed: () => formatText('h5'),
                      ),
                      CupertinoContextMenuAction(
                        child: const Text('Heading 6'),
                        onPressed: () => formatText('h6'),
                      ),
                    ],
                  child: CupertinoButton(
                      child: const Icon(CupertinoIcons.textformat),
                      onPressed: () {}))
              : PopupMenuButton<String>(
                  icon: const Text('H', style: TextStyle(fontSize: 16)),
                  tooltip: 'Headings',
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem(value: 'h1', child: Text('Heading 1')),
                    const PopupMenuItem(value: 'h2', child: Text('Heading 2')),
                    const PopupMenuItem(value: 'h3', child: Text('Heading 3')),
                    const PopupMenuItem(value: 'h4', child: Text('Heading 4')),
                    const PopupMenuItem(value: 'h5', child: Text('Heading 5')),
                    const PopupMenuItem(value: 'h6', child: Text('Heading 6')),
                  ],
                  onSelected: (value) => formatText(value),
                ),
          UniversalPlatform.isIOS
              ? CupertinoButton(
                  child: const Icon(CupertinoIcons.photo),
                  onPressed: () => showImageSheet(),
                )
              : IconButton(
                  onPressed: () => showImageSheet(),
                  icon: const Icon(Symbols.image),
                  tooltip: 'Insert Image',
                ),
          UniversalPlatform.isIOS
              ? CupertinoButton(
                  child: const Icon(CupertinoIcons.link),
                  onPressed: () => showLinkSheet(),
                )
              : IconButton(
                  onPressed: () => showLinkSheet(),
                  icon: const Icon(Symbols.link),
                  tooltip: 'Insert Link',
                ),
        ],
      ),
    );
  }

  formatText(String opt) {
    final selectedText =
        widget.controller.selection.textInside(widget.controller.text);
    final beforeText =
        widget.controller.selection.textBefore(widget.controller.text);
    final afterText =
        widget.controller.selection.textAfter(widget.controller.text);
    setState(() {
      if (selectedText.isNotEmpty || imgDescController.text.isNotEmpty) {
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
                '$beforeText![${imgDescController.text}](${imgUrlController.text})$afterText';
            imgDescController.text = "";
            imgUrlController.text = "";
            break;
          case 'link':
            widget.controller.text =
                '$beforeText[${linkNameController.text}](${linkUrlController.text})$afterText';
            linkNameController.text = "";
            linkUrlController.text = "";
            break;
          default:
        }
      }
    });
  }

  void showImageSheet() {
    final selectedText =
        widget.controller.selection.textInside(widget.controller.text);
    setState(() {
      imgDescController.text = selectedText;
    });
    if (UniversalPlatform.isIOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return Container();
          });
    } else {
      showModalBottomSheet(
          context: context,
          isDismissible: false,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) {
            return Padding(
              padding: kGlobalOuterPadding * 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Insert Image',
                        style: TextStyle(fontSize: 18),
                      ),
                      CloseButton(
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  kVSpace,
                  TextField(
                    autofocus: true,
                    controller: imgDescController,
                    decoration: const InputDecoration(
                        labelText: 'Enter Image Description'),
                  ),
                  kVSpace,
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: imgUrlController,
                          decoration: InputDecoration(
                            labelText: 'Enter Image URL',
                            hintText: 'http://',
                            suffixIcon: IconButton(
                              onPressed: () => pickImage(),
                              icon: const Icon(Symbols.more_horiz),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  kVSpace,
                  FilledButton.tonal(
                    onPressed: () {
                      formatText('image');
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            );
          });
    }
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      imgUrlController.text = file.path;
      setState(() {});
    } else {
      // User canceled the picker
    }
  }

  void showLinkSheet() {
    final selectedText =
        widget.controller.selection.textInside(widget.controller.text);
    setState(() {
      linkNameController.text = selectedText;
    });
    if (UniversalPlatform.isIOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return Container();
          });
    } else {
      showModalBottomSheet(
          context: context,
          isDismissible: false,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) {
            return Padding(
              padding: kGlobalOuterPadding * 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Insert Link',
                        style: TextStyle(fontSize: 18),
                      ),
                      CloseButton(
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  kVSpace,
                  TextField(
                    autofocus: true,
                    controller: linkNameController,
                    decoration:
                        const InputDecoration(labelText: 'Enter Link Name'),
                  ),
                  kVSpace,
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: linkUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Enter URL Address',
                            hintText: 'http://',
                          ),
                        ),
                      ),
                    ],
                  ),
                  kVSpace,
                  FilledButton.tonal(
                    onPressed: () {
                      formatText('link');
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            );
          });
    }
  }
}
