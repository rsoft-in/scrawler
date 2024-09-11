import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/helpers/utility.dart';
import 'package:scrawler/models/notes.dart';
import 'package:scrawler/widgets/scrawl_color_dot.dart';

class LinuxNoteView extends StatefulWidget {
  final Notes note;
  final VoidCallback onEditClicked;
  final VoidCallback onDeleteClicked;
  const LinuxNoteView({
    super.key,
    required this.note,
    required this.onEditClicked,
    required this.onDeleteClicked,
  });

  @override
  State<LinuxNoteView> createState() => _LinuxNoteViewState();
}

class _LinuxNoteViewState extends State<LinuxNoteView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPaddingLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.note.noteTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ScrawlColorDot(colorCode: widget.note.noteColor),
              if (widget.note.noteFavorite)
                const Icon(
                  Symbols.favorite,
                  color: Colors.red,
                ),
              IconButton(
                onPressed: () => widget.onEditClicked(),
                icon: const Icon(Symbols.edit),
              ),
              PopupMenuButton<int>(
                icon: const Icon(Symbols.more_vert),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 0,
                      child: ListTile(
                        leading: Icon(Symbols.palette),
                        title: Text('Color'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        leading: Icon(Symbols.label),
                        title: Text('Label'),
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 2,
                      child: ListTile(
                        leading: Icon(Symbols.delete),
                        title: Text('Delete'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: ListTile(
                        leading: Icon(Symbols.favorite),
                        title: Text('Add to Favorites'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 4,
                      child: ListTile(
                        leading: Icon(Symbols.archive),
                        title: Text('Archive'),
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  switch (value) {
                    case 2:
                      widget.onDeleteClicked();
                      break;
                    default:
                  }
                },
              ),
            ],
          ),
          kVSpace,
          Text(
            Utility.formatDateTime(widget.note.noteDate),
            style: const TextStyle(color: Colors.grey),
          ),
          kVSpace,
          Expanded(
            child: Markdown(
              padding: EdgeInsets.zero,
              data: widget.note.noteText,
            ),
          ),
        ],
      ),
    );
  }
}
