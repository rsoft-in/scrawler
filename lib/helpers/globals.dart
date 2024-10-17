library;

import 'package:flutter/material.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/models/notes.dart';
import 'package:scrawler/models/users_model.dart';

ThemeMode themeMode = ThemeMode.system;

User? user;
String apiKey = '';
String apiServer = '';

Notes selectedNote = Notes.empty();

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
