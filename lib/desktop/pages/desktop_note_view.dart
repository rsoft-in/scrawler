import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/helpers/utility.dart';
import 'package:scrawler/models/notes.dart';

import '../../widgets/scrawl_color_dot.dart';

class DesktopNoteView extends StatefulWidget {
  final Notes note;
  final VoidCallback onEditClicked;
  final VoidCallback onDeleteClicked;
  final VoidCallback onColorPickerClicked;
  final VoidCallback onSidebarClicked;
  final bool showSidebar;
  const DesktopNoteView({
    super.key,
    required this.note,
    required this.onEditClicked,
    required this.onDeleteClicked,
    required this.onColorPickerClicked,
    required this.onSidebarClicked,
    required this.showSidebar,
  });

  @override
  State<DesktopNoteView> createState() => _DesktopNoteViewState();
}

class _DesktopNoteViewState extends State<DesktopNoteView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Row(
          //   children: [
          //     Expanded(
          //       child: Text(
          //         widget.note.noteTitle,
          //         style: const TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //     ScrawlColorDot(colorCode: widget.note.noteColor),
          //     if (widget.note.noteFavorite)
          //       const Icon(
          //         Symbols.favorite,
          //         color: Colors.red,
          //       ),

          //   ],
          // ),
          // if (!widget.showSidebar)
          //   const SizedBox(
          //     height: 20,
          //   ),
          Row(
            children: [
              AnimatedContainer(
                width: !widget.showSidebar ? 70.0 : 0.0,
                // height: !widget.showSidebar ? 100.0 : 200.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                child: Container(
                  width: 0,
                ),
              ),
              IconButton(
                  onPressed: () => widget.onSidebarClicked(),
                  icon: const Icon(Symbols.dock_to_right)),
              Text(
                widget.note.noteTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ScrawlColorDot(colorCode: widget.note.noteColor),
              kHSpace,
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
                    case 0:
                      widget.onColorPickerClicked();
                      break;
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
          Expanded(
            child: Markdown(
              padding: EdgeInsets.zero,
              data: widget.note.noteText,
              selectable: true,
              softLineBreak: true,
            ),
          ),
          kVSpace,
          Text(
            Utility.formatDateTime(widget.note.noteDate),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
