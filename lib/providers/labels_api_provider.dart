import 'dart:convert';

import 'package:bnotes/models/label.dart';
import 'package:http/http.dart' as http;
import 'package:bnotes/helpers/globals.dart' as globals;

class LabelsApiProvider {
  static Future<LabelsData> fecthLabels(Map post) async {
    String result = "";
    try {
      var response = await http.Client()
          .post(Uri.parse("${globals.apiServer}/labels/get"), body: post);
      result = response.body;
      if (response.statusCode == 200) {
        var parsed = json.decode(result);
        if (parsed['error'] != null) {
          return LabelsData([], parsed['records'], parsed['error']);
        } else {
          var labels = parsed['labels']
              .map<Label>((json) => Label.fromJson(json))
              .toList();
          return LabelsData(labels, parsed['records'], '');
        }
      } else {
        return LabelsData([], 0, 'ERROR: $result');
      }
    } catch (e) {
      return LabelsData([], 0, 'ERROR: $e');
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
