import 'package:flutter/material.dart';

const kAppName = 'scrawler';
const kAppVersion = '2.0';
const kWebsiteUrl = 'https://scrawler.net';
const kGithubUrl = 'https://github.com/rsoft-in/scrawler';

const kPrimaryColor = Color(0xFF5066A4);
const kAlertColor = Color(0xFFD12A4C);

// const kLightPrimary = Color(0xFFF8F8F8);
// const kLightSecondary = Color(0xFFF4F4F4);
// const kLightStroke = Color(0xFFDBDBDB);
// const kLightScaffold = Color(0xFFFFFFFF);
// const kLightSelected = Color(0xFFEFEFEF);

// const kDarkPrimary = Color(0xFF262626);
// const kDarkSecondary = Color(0xFF1D1D1D);
// const kDarkStroke = Color(0xFF363636);
// const kDarkScaffold = Color(0xFF191919);
// const kDarkSelected = Color(0xFFF4F4F4);
// const kDarkBody = Color(0xFF1A1A1A);

const kBorderRadius = 8.0;
const kBorderRadiusSmall = 5.0;
const kPaddingLarge = EdgeInsets.all(15.0);
const kPaddingMedium = EdgeInsets.all(8.0);
const kGlobalOuterPadding = EdgeInsets.all(10.0);
const kGlobalCardPadding = EdgeInsets.all(5.0);
const kGlobalBorderRadius = 8.0;
const kLinkColor = Color(0xFF001AFF);
const kVSpace = SizedBox(height: 15.0);
const kHSpace = SizedBox(width: 10.0);
const kButtonPadding = EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0);
const kEmailRegEx =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

// Menu Items
const kMenu = [
  {
    'id': 'all_notes',
    'index': 0,
    'icon': Icons.note_outlined,
    'icon_filled': Icons.note,
    'text': 'notes',
  },
  {
    'id': 'all_tasks',
    'index': 1,
    'icon': Icons.task_outlined,
    'icon_filled': Icons.task,
    'text': 'tasks',
  },
];

const kMenuMobile = [
  {
    'id': 'all_notes',
    'index': 0,
    'icon': Icons.note_outlined,
    'icon_filled': Icons.note,
    'text': 'notes',
  },
  {
    'id': 'settings',
    'index': 1,
    'icon': Icons.task_outlined,
    'icon_filled': Icons.task,
    'text': 'settings',
  },
];
