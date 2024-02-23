import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class MarkdownToolbar extends StatefulWidget {
  final TextEditingController controller;
  const MarkdownToolbar({Key? key, required this.controller}) : super(key: key);

  @override
  State<MarkdownToolbar> createState() => _MarkdownToolbarState();
}

class _MarkdownToolbarState extends State<MarkdownToolbar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Symbols.undo),
            tooltip: 'Undo',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Symbols.redo),
            tooltip: 'Redo',
          ),
          const VerticalDivider(),
          IconButton(
            onPressed: () => formatText('bold'),
            icon: const Icon(Symbols.format_bold),
            tooltip: 'Bold',
          ),
          IconButton(
            onPressed: () => formatText('italic'),
            icon: const Icon(Symbols.format_italic),
            tooltip: 'Italic',
          ),
          IconButton(
            onPressed: () => formatText('ul'),
            icon: const Icon(Symbols.format_list_bulleted),
            tooltip: 'Bulleted List',
          ),
          IconButton(
            onPressed: () => formatText('ol'),
            icon: const Icon(Symbols.format_list_numbered),
            tooltip: 'Numbered List',
          ),
          PopupMenuButton<String>(
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Symbols.image),
            tooltip: 'Insert Image',
          ),
          IconButton(
            onPressed: () {},
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
      if (selectedText.isNotEmpty) {
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
          default:
        }
      }
    });
  }
}
