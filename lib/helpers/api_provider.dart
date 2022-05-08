import 'dart:convert';

import 'package:bnotes/common/constants.dart';
import 'package:bnotes/models/users_model.dart';
import 'package:http/http.dart' as http;

class ApiProvider {

  static Future<List<Users>> fetchClients(Map _post) async {
    try {
      var response = await http.Client()
          .post(Uri.parse(kBaseUrl + "checkUser"), body: _post);
      if (response.statusCode == 200) {
        String result = response.body;
        if (result.contains("{")) {
          final parsed = json.decode(result).cast<Map<String, dynamic>>();
          return parsed.map<Users>((json) => Users.fromJson(json)).toList();
        } else {
          print(result);
          return [];
        }
      } else {
        print('Users: ' + response.body);
        return [];
      }
    } on Exception catch (e) {
      print('Users: ' + e.toString());
      return [];
    }
  }
}
