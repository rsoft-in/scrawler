import 'dart:convert';

import 'package:bnotes/common/constants.dart';
import 'package:bnotes/models/users_model.dart';

import 'package:http/http.dart' as http;

class UserApiProvider {
  static Future<Map<String, dynamic>> checkUserCredential(Map post) async {
    String result = "";
    try {
      var response = await http.Client()
          .post(Uri.parse(kBaseUrl + "users/signIn"), body: post);
      result = response.body;
      print(result);
      if (response.statusCode == 200) {
        var parsed = jsonDecode(result);
        if (parsed['error'] != null) {
          return {'user': null, 'error': parsed['messages']['error']};
        } else {
          var user = new User.fromJson(parsed['user']);
          return {'user': user, 'error': ''};
        }
      } else {
        print(result);
        return {'user': null, 'error': result};
      }
    } catch (ex) {
      return {'user': null, 'error': ex.toString()};
    }
  }
}
