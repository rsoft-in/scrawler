import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:bnotes/common/constants.dart';
import 'package:bnotes/widgets/small_appbar.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/helpers/storage.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class BackupRestorePage extends StatefulWidget {
  BackupRestorePage({
    Key? key,
  }) : super(key: BackupRestorePage.staticGlobalKey);

  static final GlobalKey<_BackupRestorePageState> staticGlobalKey =
      new GlobalKey<_BackupRestorePageState>();

  @override
  _BackupRestorePageState createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  Storage storage = new Storage();
  String backupPath = "";
  bool isUploading = false;
  bool isLoading = false;
  final dbHelper = DatabaseHelper.instance;
  late SharedPreferences sharedPreferences;
  bool isLogged = false;

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (isLogged = (sharedPreferences.getBool('is_logged') ?? false) &&
          (sharedPreferences.getBool('nextcloud_backup') ?? false))
        isUploading = true;
    });
    print(isLogged);
  }

  setPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {});
  }

  Future<void> _getBackupPath() async {
    final _path = await storage.localPath;
    setState(() {
      backupPath = _path;
    });
  }

  Future _makeBackup() async {
    var _notes = await dbHelper.getNotesAllForBackup();
    String out = "";
    _notes.forEach((element) {
      out += "{\"note_id\":\"${element.noteId}\", " +
          "\"note_date\": \"${element.noteDate}\", " +
          "\"note_title\": \"${element.noteTitle}\", " +
          "\"note_text\": \"${element.noteText.replaceAll('\n', '\\n')}\", " +
          "\"note_label\": \"${element.noteLabel}\", " +
          "\"note_archived\": ${element.noteArchived}, " +
          "\"note_color\": ${element.noteColor} },";
    });
    if (_notes.length > 0) {
      if (UniversalPlatform.isAndroid) {
        await storage
            .writeData("[" + out.substring(0, out.length - 1) + "]")
            .then((value) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Backup done'),
            ),
          );
        });
      }
      if (UniversalPlatform.isIOS) {
        await storage
            .writeiOSData("[" + out.substring(0, out.length - 1) + "]")
            .then((value) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Backup done'),
            ),
          );
        });
      }
      if (isUploading) {
        try {
          final client = NextCloudClient.withCredentials(
            Uri(host: sharedPreferences.getString('nc_host')),
            sharedPreferences.getString('nc_username') ?? '',
            sharedPreferences.getString('nc_password') ?? '',
          );

          await client.webDav.upload(
              File(backupPath + '/bnotes.backup').readAsBytesSync(),
              '/bnotes.backup');
        } on RequestException catch (e, stacktrace) {
          print(e.statusCode);
          print(e.body);
          print(stacktrace);
        }
      }
    }

    // Future listFiles(NextCloudClient client) async {
    //   final files = await client.webDav.ls('/');
    //   for (final file in files) {
    //     print(file.path);
    //   }
    // }

    // Future getdata() async {
    //   sharedPreferences = await SharedPreferences.getInstance();
    // }
  }

  Future _restore() async {
    if (isUploading) {
      showLoaderDialog(context);
      try {
        final client = NextCloudClient.withCredentials(
          Uri(host: sharedPreferences.getString('nc_host')),
          sharedPreferences.getString('nc_username') ?? '',
          sharedPreferences.getString('nc_password') ?? '',
        );

        // final downloadedData =
        //     await client.webDav.downloadStream('/bnotes.backup').then((value) { print(value);});
        // ignore: unused_local_variable
        final downloadedBytes =
            client.webDav.download('/bnotes.backup').then((value) {
          print(value);
          String restoredString = new String.fromCharCodes(value);
          final parsed =
              json.decode(restoredString).cast<Map<String, dynamic>>();
          List<Notes> notesList = [];
          notesList =
              parsed.map<Notes>((json) => Notes.fromJson(json)).toList();
          dbHelper.deleteNotesAll();
          notesList.forEach((element) {
            // Test back resoration from old version backup to check if note_list field gives error
            dbHelper.insertNotes(new Notes(
                element.noteId,
                element.noteDate,
                element.noteTitle,
                element.noteText,
                element.noteLabel,
                element.noteArchived,
                element.noteColor,
                element.noteList));
          });
          Navigator.pop(context);
          Navigator.pop(context, 'yes');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Restored'),
            ),
          );
        });
        // final file = File(backupPath + '/bnotes.backup');
        // if (file.existsSync()) {
        //   file.deleteSync();
        // }
        // final inputStream = file.openWrite();
        // await inputStream.addStream(downloadedData).then((value) {
        //   inputStream.close();
        // });
      } on RequestException catch (e, stacktrace) {
        print(e.statusCode);
        print(e.body);
        print(stacktrace);
      }
    } else {
      await storage.readData().then((value) {
        final parsed = json.decode(value).cast<Map<String, dynamic>>();
        List<Notes> notesList = [];
        notesList = parsed.map<Notes>((json) => Notes.fromJson(json)).toList();
        dbHelper.deleteNotesAll();
        notesList.forEach((element) {
          dbHelper.insertNotes(new Notes(
              element.noteId,
              element.noteDate,
              element.noteTitle,
              element.noteText,
              element.noteLabel,
              element.noteArchived,
              element.noteColor,
              element.noteList));
        });
        Navigator.pop(context, 'yes');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Restored'),
          ),
        );
      });
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      elevation: 1,
      title: Text('Restoring'),
      content: new Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(
            width: 10,
          ),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text('Please wait')),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    getPref();
    _getBackupPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: SAppBar(
          title: 'Backup & Restore',
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: <Widget>[
            // SizedBox(
            //   height: 80,
            // ),
            Icon(
              Iconsax.document_download5,
              size: 100,
              color: darkModeOn ? Colors.white54 : Colors.black26,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: kGlobalOuterPadding,
              child: Text(
                'Back up your notes onto your device/Nextcloud. You can restore the backup when you reinstall scrawl.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text('Back path'),
              subtitle: Text(backupPath),
            ),
            Divider(),
            ListTile(
              title: Text('Use Nextcloud'),
              trailing: Switch.adaptive(
                value: isUploading,
                onChanged: (value) {
                  setState(() {
                    isUploading = value;
                    sharedPreferences.setBool('nextcloud_backup', isUploading);
                    print(isUploading);
                  });
                },
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _makeBackup(),
                    icon: Icon(Iconsax.document_upload),
                    label: Text('Backup'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _restore(),
                    icon: Icon(Iconsax.document_download),
                    label: Text('Restore'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
