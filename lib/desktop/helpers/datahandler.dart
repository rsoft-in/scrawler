import 'dart:convert';
import 'dart:io';

import 'package:bnotes/models/labels_model.dart';
import 'package:bnotes/models/notes_model.dart';

class DataHandler {
  static String path = Directory.current.path;

  static Future<List<Notes>> fetchNotes() async {
    try {
      final file = File('$path/data/notes.json');
      final content = await file.readAsString();
      final parsed = json.decode(content).cast<Map<String, dynamic>>();
      return parsed.map<Notes>((json) => Notes.fromJson(json)).toList();
    } on Exception catch (e) {
      return [];
    }
  }

  static Future<List<Labels>> fetchLabels() async {
    try {
      final file = File('$path/data/labels.json');
      final content = await file.readAsString();
      final parsed = json.decode(content).cast<Map<String, dynamic>>();
      return parsed.map<Labels>((json) => Labels.fromJson(json)).toList();
    } on Exception catch (e) {
      return [];
    }
  }
}
