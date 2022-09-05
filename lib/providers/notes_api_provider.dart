import 'dart:convert';

import 'package:bnotes/common/constants.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:http/http.dart' as http;

class NotesApiProvider {
  static Future<NotesResult> fecthNotes(Map post) async {
    String result = "";
    try {
      var response = await http.Client()
          .post(Uri.parse("$kBaseUrl/notes/get"), body: post);
      result = response.body;
      if (response.statusCode == 200) {
        var parsed = json.decode(result);
        if (parsed['error'] != null) {
          return NotesResult([], parsed['records'], parsed['error']);
        } else {
          var notes = parsed['notes']
              .map<Notes>((json) => Notes.fromJson(json))
              .toList();
          return NotesResult(notes, parsed['records'], '');
        }
      } else {
        return NotesResult([], 0, result);
      }
    } catch (e) {
      return NotesResult([], 0, e.toString());
    }
  }
}
