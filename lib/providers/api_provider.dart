import 'package:flutter/services.dart';

class ApiProvider {
  static Future<String> fetchAPIKey() async {
    try {
      String _key = await rootBundle.loadString('res/apikey');
      return _key;
    } catch (e) {
      return '';
    }
  }
}
