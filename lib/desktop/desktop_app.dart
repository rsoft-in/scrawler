import 'package:bnotes/desktop/pages/desktop_home_page.dart';
import 'package:bnotes/desktop/pages/desktop_sign_in.dart';
import 'package:bnotes/models/users_model.dart';
import 'package:bnotes/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bnotes/common/globals.dart' as globals;

class DesktopApp extends StatefulWidget {
  const DesktopApp({Key? key}) : super(key: key);

  @override
  State<DesktopApp> createState() => _DesktopAppState();
}

class _DesktopAppState extends State<DesktopApp> {
  late SharedPreferences prefs;
  bool isSignedIn = false;

  getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    isSignedIn = prefs.getBool('is_signed_in') ?? false;
    globals.apiKey = await ApiProvider.fetchAPIKey();
    User user = User('', '', '', '', '', false);
    user.userId = prefs.getString('user_id') ?? '';
    user.userEmail = prefs.getString('user_email') ?? '';
    user.userName = prefs.getString('user_name') ?? '';
    user.userOtp = prefs.getString('user_otp') ?? '';
    user.userPwd = prefs.getString('user_pwd') ?? '';
    user.userEnabled = prefs.getBool('user_enabled') ?? false;
    globals.user = user;
    if (!isSignedIn) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => new DesktopSignIn()),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => new DesktopHomePage()),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
