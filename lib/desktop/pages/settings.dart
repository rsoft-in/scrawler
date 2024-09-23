import 'package:flutter/material.dart';
import 'package:scrawler/helpers/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('About this app'),
          onTap: () => showAboutDialog(
              context: context,
              applicationName: kAppName,
              applicationVersion: kAppVersion,
              applicationLegalese: 'RSoft',
              applicationIcon: Image.asset(
                'images/scrawler-desktop.png',
                scale: 6,
              )),
        ),
      ],
    );
  }
}
