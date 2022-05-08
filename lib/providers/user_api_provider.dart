import 'dart:convert';

import 'package:bnotes/common/constants.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:http/http.dart' as http;

class UserApiProvider {
  static Future<User?> checkUserCredential(Map post) async {
    String result = "";
    try {
      var loginResponse = await http.Client()
          .post(Uri.parse(kBaseUrl + "services/checkUser"), body: post);
      result = loginResponse.body;
      print(result);
      if (result.contains('{')) {
        Map<String, dynamic> userMap = jsonDecode(result);
        var user = new User.fromJson(userMap);
        return user;
      } else {
        print(result);
        return null;
      }
    } catch (ex) {
      result = "Unable to check!\n" + ex.toString();
      return null;
    }
  }
}
