import 'package:bnotes/desktop/pages/desktop_home_page.dart';
import 'package:bnotes/desktop/pages/desktop_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesktopApp extends StatefulWidget {
  const DesktopApp({Key? key}) : super(key: key);

  @override
  State<DesktopApp> createState() => _DesktopAppState();
}

class _DesktopAppState extends State<DesktopApp> {
  late SharedPreferences sharedPreferences;
  bool isSignedIn = false;

  getPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    isSignedIn = sharedPreferences.getBool('is_signed_in') ?? false;
    print(isSignedIn);
    if (!isSignedIn) {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (BuildContext context) => new DesktopSignIn()),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
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
