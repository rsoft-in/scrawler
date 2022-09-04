import 'package:flutter/material.dart';

const kAppName = 'scrawl';
const kBaseUrl = 'https://scrawl.knoxxbox.in/api';

const kPrimaryColor = Color(0xFF18837c);
const kAccentColor = Color(0xFFA3D2CA);
const kSecondaryColor = Color(0xFFEB5E0B);
const kSecondaryDark = Color(0xff1c1c1c);
const kScaffoldDark = Color(0xFF121212);
const kTextColor = Color(0xFF757575);
const kBorderColor = Color(0xFFE5E5E5);
const kGlobalOuterPadding = EdgeInsets.all(10.0);
const kGlobalCardPadding = EdgeInsets.all(5.0);
const kGlobalTextPadding =
    EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0);
const kLinkColor = Color(0xFF001AFF);
const kVSpace = SizedBox(height: 15.0);
const kHSpace = SizedBox(width: 10.0);
const kButtonBorderRadius = 15.0;
const kInputDecorationBorderRadius = 15.0;
const kCardBorderRadius = 15.0;
const kButtonPadding = EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0);
const kInputDecorationPadding =
    EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0);
const kBackGroundGradient = BoxDecoration(
    gradient: LinearGradient(
        colors: [Color(0xFF0072A2), Color(0xFF18837c), Color(0xFF33b864)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight));

const kEmailRegEx =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
