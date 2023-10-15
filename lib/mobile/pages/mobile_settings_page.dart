import 'dart:io';

import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/mobile/pages/mobile_about_page.dart';
import 'package:bnotes/models/notes.dart';
import 'package:bnotes/widgets/scrawl_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/dbhelper.dart';

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
            onTap: () => onBackRestore(),
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

  void onBackRestore() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Select'),
            children: [
              ListTile(
                title: const Text('Backup Notes'),
                onTap: () {
                  backupData(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Restore from Backup'),
                onTap: () {},
              ),
            ],
          );
        });
  }

  void backupData(BuildContext context) async {
    var notesList = await getNotes();
    final file = await _localFile;
    file.writeAsString(notesList.toString());
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(ScrawlSnackBar.show(
        context, 'Backup stored at ${file.path}',
        duration: const Duration(seconds: 2)));
  }

  Future<String> get _localPath async {
    final directory = await getDownloadsDirectory();
    return directory!.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/scrawler.backup');
  }

  Future<List<Notes>> getNotes() async {
    final dbHelper = DBHelper.instance;
    var result = await dbHelper.getNotesAll('', 'note_id');
    return result;
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
      Phoenix.rebirth(context);
    });
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
