import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scrawler/src/helpers/globals.dart' as globals;
import 'package:scrawler/src/models/notes.dart';

class NotesApiProvider {
  static Future<NotesResult> getNotes(String post) async {
    String result = "";
    try {
      var response = await http.Client().post(
          Uri.parse("${globals.apiServer}/getnotes"),
          headers: {'Content-Type': 'application/json'},
          body: post);
      result = response.body;
      print(result);
      if (response.statusCode == 200) {
        var parsed = json.decode(result);
        var notes = parsed.map<Notes>((json) => Notes.fromJson(json)).toList();
        return NotesResult(notes, 0, '');
      } else {
        return NotesResult([], 0, result);
      }
    } catch (e) {
      return NotesResult([], 0, '$e');
    }
  }

  static Future<NotesResult> getNoteText(String post) async {
    String result = "";
    try {
      var response = await http.Client().post(
          Uri.parse("${globals.apiServer}/getnotetext"),
          headers: {'Content-Type': 'application/json'},
          body: post);
      result = response.body;
      if (response.statusCode == 200) {
        var parsed = json.decode(result);
        var notes = parsed.map<Notes>((json) => Notes.fromJson(json)).toList();
        return NotesResult(notes, 0, '');
      } else {
        return NotesResult([], 0, result);
      }
    } catch (e) {
      return NotesResult([], 0, '$e');
    }
  }

  static Future<Map<String, dynamic>> update(String post) async {
    String result = "";
    try {
      var response = await http.Client().post(
          Uri.parse('${globals.apiServer}/updatenote'),
          headers: {'Content-Type': 'application/json'},
          body: post);
      result = response.body;
      if (response.statusCode == 200) {
        return {'status': true, 'error': ''};
      } else {
        return {'status': false, 'error': result};
      }
    } catch (e) {
      return {'status': false, 'error': '$e'};
    }
  }

  static Future<Map<String, dynamic>> updateFavorite(String post) async {
    String result = "";
    try {
      var response = await http.Client().post(
          Uri.parse('${globals.apiServer}/updatefavnote'),
          headers: {'Content-Type': 'application/json'},
          body: post);
      result = response.body;
      if (response.statusCode == 200) {
        return {'status': true, 'error': ''};
      } else {
        return {'status': false, 'error': result};
      }
    } catch (e) {
      return {'status': false, 'error': '$e'};
    }
  }

  static Future<Map<String, dynamic>> updateColor(String post) async {
    String result = "";
    try {
      var response = await http.Client().post(
          Uri.parse('${globals.apiServer}/updatenotecolor'),
          headers: {'Content-Type': 'application/json'},
          body: post);
      result = response.body;
      if (response.statusCode == 200) {
        return {'status': true, 'error': ''};
      } else {
        return {'status': false, 'error': result};
      }
    } catch (e) {
      return {'status': false, 'error': '$e'};
    }
  }

  static Future<Map<String, dynamic>> updateLabel(String post) async {
    String result = "";
    try {
      var response = await http.Client().post(
          Uri.parse('${globals.apiServer}/updatenotelabel'),
          headers: {'Content-Type': 'application/json'},
          body: post);
      result = response.body;
      if (response.statusCode == 200) {
        return {'status': true, 'error': ''};
      } else {
        return {'status': false, 'error': result};
      }
    } catch (e) {
      return {'status': false, 'error': '$e'};
    }
  }

  static Future<Map<String, dynamic>> delete(String post) async {
    String result = "";
    try {
      var response = await http.Client().post(
          Uri.parse('${globals.apiServer}/deletenote'),
          headers: {'Content-Type': 'application/json'},
          body: post);
      result = response.body;
      if (response.statusCode == 200) {
        return {'status': true, 'error': ''};
      } else {
        return {'status': false, 'error': result};
      }
    } catch (e) {
      return {'status': false, 'error': '$e'};
    }
  }
}
