import 'dart:convert';

import 'package:bnotes/common/constants.dart';
import 'package:bnotes/models/users_model.dart';

import 'package:http/http.dart' as http;

class UserApiProvider {
  static Future<Map<String, dynamic>> checkUserCredential(Map post) async {
    String result = "";
    try {
      var response = await http.Client()
          .post(Uri.parse("$kBaseUrl/users/signIn"), body: post);
      result = response.body;
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

  static Future<Map<String, dynamic>> sendVerification(Map post) async {
    String result = '';
    try {
      var response = await http.Client()
          .post(Uri.parse('$kBaseUrl/users/sendVerification'), body: post);
      result = response.body;
      if (response.statusCode == 200 && result.contains('SUCCESS')) {
        return {'status': true, 'error': ''};
      } else {
        return {'status': false, 'error': result};
      }
    } catch (e) {
      return {'status': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(Map post) async {
    String result = '';
    try {
      var response = await http.Client()
          .post(Uri.parse('$kBaseUrl/users/verifyOtp'), body: post);
      result = response.body;
      if (response.statusCode == 200 && result.contains('user_id')) {
        var parsed = json.decode(result).cast<Map<String, dynamic>>();
        var user = parsed.map<User>((json) => User.fromJson(json)).toList()[0];
        return {'user': user, 'error': ''};
      } else {
        return {'user': null, 'error': result};
      }
    } catch (e) {
      return {'user': null, 'error': e.toString()};
    }
  }
}
