library;

import 'package:flutter/material.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/models/notes.dart';
import 'package:scrawler/src/models/user.dart';

ThemeMode themeMode = ThemeMode.system;

User user = User.empty();
String apiKey = '';
String apiServer = '';
String secretKey = '';

Notes selectedNote = Notes.empty();

List<Map<String, dynamic>> openNotes = [{"index": 0, "note": null}];

int currentTab = 0;

Color selectedSeedColor = kPrimaryColor;

List<Color> appColors = [
  kPrimaryColor,
  const Color(0xFFB54769),
  const Color(0xFF558CFF),
  const Color(0xFF8F62AC),
  Color(0xFF326449),
  Colors.deepOrange,
  Colors.deepPurple
];
