import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';

const kAppName = 'scrawler';
const kWebsiteUrl = 'https://scrawler.net';

const kPrimaryColor = Color(0xFF5EAAA8);
const kAlertColor = Color(0xFFD12A4C);

const kLightPrimary = Color(0xFFF8F8F8);
const kLightSecondary = Color(0xFFF4F4F4);
const kLightStroke = Color(0xFFDBDBDB);
const kLightScaffold = Color(0xFFFFFFFF);
const kLightSelected = Color(0xFFEFEFEF);

const kDarkPrimary = Color(0xFF262626);
const kDarkSecondary = Color(0xFF1D1D1D);
const kDarkStroke = Color(0xFF363636);
const kDarkScaffold = Color(0xFF191919);
const kDarkSelected = Color(0xFFF4F4F4);
const kDarkBody = Color(0xFF1A1A1A);

const kBorderRadius = 10.0;
const kBorderRadiusSmall = 5.0;
const kPaddingLarge = EdgeInsets.all(15.0);
const kGlobalOuterPadding = EdgeInsets.all(10.0);
const kGlobalCardPadding = EdgeInsets.all(5.0);
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
    'icon': YaruIcons.text_editor,
    'icon_filled': YaruIcons.text_editor,
    'text': 'notes',
  },
  {
    'id': 'all_tasks',
    'index': 1,
    'icon': YaruIcons.unordered_list,
    'icon_filled': YaruIcons.unordered_list,
    'text': 'tasks',
  },
];

const kMenuMobile = [
  {
    'id': 'all_notes',
    'index': 0,
    'icon': YaruIcons.text_editor,
    'icon_filled': YaruIcons.text_editor,
    'text': 'notes',
  },
  {
    'id': 'all_tasks',
    'index': 1,
    'icon': YaruIcons.unordered_list,
    'icon_filled': YaruIcons.unordered_list,
    'text': 'tasks',
  },
  {
    'id': 'settings',
    'index': 2,
    'icon': YaruIcons.settings,
    'icon_filled': YaruIcons.settings,
    'text': 'settings',
  },
];
