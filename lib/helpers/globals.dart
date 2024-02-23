library scrawl.globals;

import 'package:bnotes/models/notes.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/models/users_model.dart';

ThemeMode themeMode = ThemeMode.system;

User? user;
String apiKey = '';
String apiServer = '';

Notes selectedNote = Notes.empty();
