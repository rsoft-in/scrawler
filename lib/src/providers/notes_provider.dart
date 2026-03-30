import 'package:flutter/material.dart';
import 'package:scrawler/src/helpers/dbhelper.dart';
import 'package:scrawler/src/model/note.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  // Filtered list for the horizontal "Recent" section (e.g., top 5)
  List<Note> get recentNotes => _notes.take(5).toList();

  Future<void> fetchNotes() async {
    final dataList = await DatabaseHelper.instance.queryAll();
    _notes = dataList.map((item) => Note.fromMap(item)).toList();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    final id = await DatabaseHelper.instance.insert(note.toMap());
    _notes.insert(0, note.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
    await fetchNotes(); // Refresh list to maintain sort order
  }

  Future<void> deleteNote(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  List<String> get allDistinctTags {
    final Set<String> distinctTags = {};
    for (var note in _notes) {
      distinctTags.addAll(note.tags);
    }
    return distinctTags.toList()..sort();
  }
}
