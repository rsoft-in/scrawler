import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
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
    return FScaffold(
      header: FHeader.nested(
        titleAlignment: Alignment.centerLeft,
        prefixes: [
          FHeaderAction.back(
            onPress: () => Navigator.pop(context),
          ),
        ],
        title: Text('settings'.tr()),
      ),
      child: SingleChildScrollView(
        child: FItemGroup(children: [
          FItem(
            prefix: Icon(FIcons.user),
            title: Text(globals.userDetails!.displayName),
            subtitle: Text(globals.userDetails!.email!),
          ),
          FItem(
            prefix: Icon(FIcons.palette),
            title: Text('appearance'.tr()),
          ),
          FItem(
            prefix: Icon(FIcons.logOut),
            title: Text('sign_out'.tr()),
            onPress: () => signOut(),
          ),
        ]),
      ),
    );
  }
}
