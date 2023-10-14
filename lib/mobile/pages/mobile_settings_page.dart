import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/mobile/pages/mobile_about_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class MobileSettingsPage extends StatefulWidget {
  const MobileSettingsPage({Key? key}) : super(key: key);

  @override
  State<MobileSettingsPage> createState() => _MobileSettingsPageState();
}

class _MobileSettingsPageState extends State<MobileSettingsPage> {
  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 10.0,
        ),
        children: [
          // ListTile(
          //   onTap: () {},
          //   leading: const Icon(CupertinoIcons.person),
          //   title: const Text('Account'),
          // ),
          // ListTile(
          //   onTap: () {},
          //   leading: const Icon(CupertinoIcons.shield),
          //   title: const Text('Security'),
          // ),
          ListTile(
            onTap: () {},
            leading: const Icon(CupertinoIcons.cloud),
            title: const Text('Backup & Restore'),
          ),
          ListTile(
            onTap: appearance,
            leading: const Icon(CupertinoIcons.brightness),
            title: const Text('Appearance'),
            subtitle: Text(globals.themeMode.name.toUpperCase()),
          ),
          // ListTile(
          //   onTap: () {},
          //   leading: const Icon(CupertinoIcons.bell),
          //   title: const Text('Notifications'),
          // ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => const MobileAboutPage()),
              );
            },
            leading: const Icon(CupertinoIcons.info),
            title: const Text('About'),
          ),
        ],
      ),
    );
  }

  void appearance() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Choose Appearance',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => onAppearanceChanged(ThemeMode.light),
                  title: const Text('Light'),
                ),
                ListTile(
                  onTap: () => onAppearanceChanged(ThemeMode.dark),
                  title: const Text('Dark'),
                ),
                ListTile(
                  onTap: () => onAppearanceChanged(ThemeMode.system),
                  title: const Text('System'),
                ),
                kVSpace,
              ],
            ),
          );
        });
  }

  void onAppearanceChanged(ThemeMode mode) async {
    prefs = await SharedPreferences.getInstance();
    int themeCode = 0;
    setState(() {
      globals.themeMode = mode;
      switch (mode) {
        case ThemeMode.light:
          themeCode = 0;
          break;
        case ThemeMode.dark:
          themeCode = 1;
          break;
        case ThemeMode.system:
          themeCode = 2;
          break;
        default:
          themeCode = 0;
          break;
      }
      prefs.setInt('themeMode', themeCode);
    });
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
