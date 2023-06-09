import 'dart:convert';
import 'dart:io';

import 'package:bnotes/models/label.dart';
import 'package:bnotes/models/notes.dart';

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
    } on Exception {
      return [];
    }
  }

  static Future<List<Label>> fetchLabels() async {
    try {
      final file = File('$path/data/labels.json');
      final content = await file.readAsString();
      final parsed = json.decode(content).cast<Map<String, dynamic>>();
      return parsed.map<Label>((json) => Label.fromJson(json)).toList();
    } on Exception {
      return [];
    }
  }

  static Future<bool> storeNotes(List<Notes> notes) async {
    try {
      final file = File('$path/data/notes.json');
      await file.writeAsString(jsonEncode(notes));
      return true;
    } on Exception {
      return false;
    }
  }

  static Future<bool> storeLabels(List<Label> labels) async {
    try {
      final file = File('$path/data/labels.json');
      await file.writeAsString(jsonEncode(labels));
      return true;
    } on Exception {
      return false;
    }
  }
}
