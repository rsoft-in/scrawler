import 'dart:convert';
import 'dart:io';

import 'package:bnotes/models/labels_model.dart';
import 'package:bnotes/models/notes_model.dart';

class LocalDataHandler {
  static String path = Directory.current.path;

  static Future<List<Notes>> fetchNotes() async {
    try {
      final dataDirectory = Directory('$path/data');
      dataDirectory.createSync();

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

  static Future<bool> storeNotes(List<Notes> notes) async {
    try {
      final file = File('$path/data/notes.json');
      await file.writeAsString(jsonEncode(notes));
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> storeLabels(List<Labels> labels) async {
    try {
      final file = File('$path/data/labels.json');
      await file.writeAsString(jsonEncode(labels));
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }
}
