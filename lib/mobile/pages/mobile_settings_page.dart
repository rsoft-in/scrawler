// import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class MobileSettingsPage extends StatefulWidget {
  const MobileSettingsPage({Key? key}) : super(key: key);

  @override
  State<MobileSettingsPage> createState() => _MobileSettingsPageState();
}

class _MobileSettingsPageState extends State<MobileSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            onTap: () {},
            leading: const Icon(CupertinoIcons.person),
            title: const Text('Account'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(CupertinoIcons.shield),
            title: const Text('Security'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(CupertinoIcons.cloud),
            title: const Text('Backup'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(CupertinoIcons.brightness),
            title: const Text('Appearance'),
            subtitle: Text(globals.themeMode.name),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(CupertinoIcons.bell),
            title: const Text('Notifications'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(CupertinoIcons.info),
            title: const Text('About'),
          ),
        ],
      ),
    );
  }
}
