import 'package:flutter/material.dart';
import 'package:scrawler/src/models/notes.dart';

class NoteView extends StatefulWidget {
  final Notes note;
  const NoteView({super.key, required this.note});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
