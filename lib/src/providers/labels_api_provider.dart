import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scrawler/src/helpers/globals.dart' as globals;
import 'package:scrawler/src/models/label.dart';

class LabelsApiProvider {
  static Future<LabelsResult> fecthLabels(String post) async {
    String result = "";
    try {
      var response = await http.Client().post(
          Uri.parse("${globals.apiServer}/getlabels"),
          headers: {'Content-Type': 'application/json'},
          body: post);
      result = response.body;
      print(result);
      if (response.statusCode == 200) {
        var parsed = json.decode(result);
        var labels = parsed.map<Label>((json) => Label.fromJson(json)).toList();
        return LabelsResult(labels, 0, '');
      } else {
        return LabelsResult([], 0, 'ERROR: $result');
      }
    } catch (e) {
      return LabelsResult([], 0, 'ERROR: $e');
    }
  }

  static Future<Map<String, dynamic>> updateLabels(Map post) async {
    String result = "";
    try {
      var response = await http.Client()
          .post(Uri.parse('${globals.apiServer}/labels/update'), body: post);
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

  static Future<Map<String, dynamic>> deleteLabels(Map post) async {
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
