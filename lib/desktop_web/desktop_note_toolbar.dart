import 'package:bnotes/helpers/utility.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../models/notes.dart';

class DesktopNoteToolbar extends StatelessWidget {
  final Notes note;
  const DesktopNoteToolbar(this.note, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Utility.formatDateTime(note.noteDate),
          style: const TextStyle(fontSize: 12),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Symbols.favorite)),
        IconButton(onPressed: () {}, icon: const Icon(Symbols.palette)),
        IconButton(onPressed: () {}, icon: const Icon(Symbols.delete)),
        IconButton(onPressed: () {}, icon: const Icon(Symbols.more_horiz)),
      ],
    );
  }
}
