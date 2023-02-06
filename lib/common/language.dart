import 'dart:convert';

import 'package:flutter/services.dart';

class Language {
  static dynamic data = {};

  static Future<void> readJson() async {
    final String response = await rootBundle.loadString('res/languages.json');
    data = json.decode(response);
  }

  static String get(String phrase) {
    return data[phrase] ?? '_$phrase';
  }
}
