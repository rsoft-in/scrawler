import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:flutter/material.dart';

class MobileSettingsPage extends StatefulWidget {
  const MobileSettingsPage({Key? key}) : super(key: key);

  @override
  State<MobileSettingsPage> createState() => _MobileSettingsPageState();
}

class _MobileSettingsPageState extends State<MobileSettingsPage> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return const Scaffold(
      body: FlutterLogo(),
    );
  }
}
