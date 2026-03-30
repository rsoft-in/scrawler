import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/providers/backup_service.dart';
import 'package:scrawler/src/screens/signin.dart';
import 'package:scrawler/src/widgets/rs_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences preferences;
  final backupService = BackupService(
    nextcloudUrl: "https://yourserver/remote.php/dav/files/username",
    username: "username",
    password: "zepj6894",
  );

  void signOut() async {
    preferences = await SharedPreferences.getInstance();
    preferences.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(CupertinoIcons.color_filter),
            title: Text('appearance'.tr()),
          ),
          ListTile(
            leading: Icon(Symbols.cloud_upload),
            title: Text("backup_restore".tr()),
            onTap: () async {
              final result = await backupService.backupToJson();
              if (!result['status'] && context.mounted) {
                RSToast.show(context, message: result['error']);
              }
            },
          ),
        ],
      ),
    );
  }
}
