library scrawl.globals;

import 'package:flutter/material.dart';
import 'package:scrawler/models/notes.dart';
import 'package:scrawler/models/users_model.dart';

ThemeMode themeMode = ThemeMode.system;

User? user;
String apiKey = '';
String apiServer = '';

Notes selectedNote = Notes.empty();
