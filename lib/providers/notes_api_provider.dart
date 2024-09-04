import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scrawler/helpers/globals.dart' as globals;
import 'package:scrawler/models/notes.dart';

class NotesApiProvider {
  static Future<NotesResult> fecthNotes(Map post) async {
    String result = "";
    try {
      var response = await http.Client()
          .post(Uri.parse("${globals.apiServer}/notes/getall"), body: post);
      result = response.body;
      if (response.statusCode == 200) {
        var parsed = json.decode(result);
        if (parsed['error'] != null) {
          return NotesResult([], parsed['records'], parsed['error']);
        } else {
          var notes = parsed['notes']
              .map<Notes>((json) => Notes.fromJson(json))
              .toList();
          return NotesResult(notes, 0, '');
        }
      } else {
        return NotesResult([], 0, result);
      }
    } catch (e) {
      return NotesResult([], 0, e.toString());
    }
  }

  static Future<Map<String, dynamic>> updateNotes(Map post) async {
    String result = "";
    try {
      var response = await http.Client()
          .post(Uri.parse('${globals.apiServer}/notes/update'), body: post);
      result = response.body;
      if (response.statusCode == 200) {
        if (result.contains('SUCCESS')) {
          return {'status': true, 'error': ''};
        } else {
          return {'status': false, 'error': result};
        }
      } else {
        return {'status': false, 'error': result};
      }
    } catch (e) {
      return {'status': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> deleteNotes(Map post) async {
    String result = "";
    try {
      var response = await http.Client()
          .post(Uri.parse('${globals.apiServer}/notes/delete'), body: post);
      result = response.body;
      if (response.statusCode == 200) {
        if (result.contains('SUCCESS')) {
          return {'status': true, 'error': ''};
        } else {
          return {'status': false, 'error': result};
        }
      } else {
        return {'status': false, 'error': result};
      }
    } catch (e) {
      return {'status': false, 'error': e.toString()};
    }
  }
}
