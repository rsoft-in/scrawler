import 'package:flutter/services.dart';

class ApiProvider {
  static Future<String> fetchAPIKey() async {
    try {
      String key = await rootBundle.loadString('res/apikey');
      return key;
    } catch (e) {
      return '';
    }
  }

  static Future<String> fetchAPIServer() async {
    try {
      String server = await rootBundle.loadString('res/apiserver');
      return server;
    } catch (e) {
      return '';
    }
  }
}
