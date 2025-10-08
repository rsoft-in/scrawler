import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/screens/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/globals.dart' as globals;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences preferences;

  void signOut() async {
    preferences = await SharedPreferences.getInstance();
    preferences.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Symbols.person),
              title: Text(globals.userDetails!.displayName),
              subtitle: Text(globals.userDetails!.email!),
            ),
            ListTile(
              leading: Icon(Symbols.palette),
              title: Text('appearance'.tr()),
            ),
            ListTile(
              leading: Icon(Symbols.exit_to_app),
              title: Text('sign_out'.tr()),
              onTap: () => signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
