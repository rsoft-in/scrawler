import 'dart:convert';

import 'package:bnotes/models/users_model.dart';

import 'package:http/http.dart' as http;
import 'package:bnotes/helpers/globals.dart' as globals;

class UserApiProvider {
  static Future<Map<String, dynamic>> checkUserCredential(Map post) async {
    String result = "";
    try {
      var response = await http.Client()
          .post(Uri.parse("${globals.apiServer}/users/signIn"), body: post);
      result = response.body;
      if (response.statusCode == 200) {
        var parsed = jsonDecode(result);
        if (parsed['error'] != null) {
          return {'user': null, 'error': parsed['messages']['error']};
        } else {
          var user = User.fromJson(parsed['user']);
          return {'user': user, 'error': ''};
        }
      } else {
        return {'user': null, 'error': result};
      }
    } catch (ex) {
      return {'user': null, 'error': ex.toString()};
    }
  }

  static Future<Map<String, dynamic>> sendVerification(Map post) async {
    String result = '';
    try {
      var response = await http.Client().post(
          Uri.parse('${globals.apiServer}/users/sendVerification'),
          body: post);
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

  static Future<Map<String, dynamic>> forgotPasswordVerification(
      Map post) async {
    String result = '';
    try {
      var response = await http.Client().post(
          Uri.parse('${globals.apiServer}/users/forgotPasswordVerification'),
          body: post);
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
          .post(Uri.parse('${globals.apiServer}/users/verifyOtp'), body: post);
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

  static Future<Map<String, dynamic>> verifyRecoveryOtp(Map post) async {
    String result = '';
    try {
      var response = await http.Client()
          .post(Uri.parse('${globals.apiServer}/users/verifyOtp'), body: post);
      result = response.body;
      if (response.statusCode == 200 && result.contains('SUCCESS')) {
        return {'response': true, 'error': ''};
      } else {
        return {'response': false, 'error': 'ERROR: $result'};
      }
    } catch (e) {
      return {'response': false, 'error': 'ERROR: $e'};
    }
  }

  static Future<Map<String, dynamic>> updatePassword(Map post) async {
    String result = '';
    try {
      var response = await http.Client().post(
          Uri.parse('${globals.apiServer}/users/updatePassword'),
          body: post);
      result = response.body;
      if (response.statusCode == 200 && result.contains('SUCCESS')) {
        return {'response': true, 'error': ''};
      } else {
        return {'response': false, 'error': 'ERROR: $result'};
      }
    } catch (e) {
      return {'response': false, 'error': 'ERROR: $e'};
    }
  }
}
