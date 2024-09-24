import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/helpers/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 70,
                ),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Symbols.arrow_back)),
                const Text(
                  'Setting',
                  style: TextStyle(
                    // fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
        ),
      ),
    );
  }
}
