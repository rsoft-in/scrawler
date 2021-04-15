import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/helpers/storage.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class BackupRestorePage extends StatefulWidget {
  @override
  _BackupRestorePageState createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  Storage storage = new Storage();
  String backupPath = "";
  bool isUploading = false;
  final dbHelper = DatabaseHelper.instance;
  SharedPreferences sharedPreferences;
  bool isLogged = false;

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (isLogged = sharedPreferences.getBool('is_logged') ?? false)
        isUploading = true;
    });
    print(isLogged);
  }

  Future<void> _getBackupPath() async {
    final _path = await storage.localPath;
    setState(() {
      backupPath = _path;
    });
  }

  Future _makeBackup() async {
    var _notes = await dbHelper.getNotesAll('');
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
      await storage
          .writeData("[" + out.substring(0, out.length - 1) + "]")
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: Text('Backup done!'),
          duration: Duration(seconds: 5),
        ));
      });
      if (isUploading) {
        try {
          final client = NextCloudClient.withCredentials(
            Uri(host: sharedPreferences.getString('nc_host')),
            sharedPreferences.getString('nc_username'),
            sharedPreferences.getString('nc_password'),
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

    Future listFiles(NextCloudClient client) async {
      final files = await client.webDav.ls('/');
      for (final file in files) {
        print(file.path);
      }
    }

    Future getdata() async {
      sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Future _restore() async {
    if (isUploading) {
      try {
        final client = NextCloudClient.withCredentials(
          Uri(host: sharedPreferences.getString('nc_host')),
          sharedPreferences.getString('nc_username'),
          sharedPreferences.getString('nc_password'),
        );

        final downloadedData =
            await client.webDav.downloadStream('/bnotes.backup');

        final file = File(backupPath + '/bnotes.backup');
        if (file.existsSync()) {
          file.deleteSync();
        }
        final inputStream = file.openWrite();
        await inputStream.addStream(downloadedData);
      } on RequestException catch (e, stacktrace) {
        print(e.statusCode);
        print(e.body);
        print(stacktrace);
      }
    }
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
            element.noteColor ?? 0));
      });
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: Text('Backup restored!'),
        duration: Duration(seconds: 5),
      ));
    });
  }

  @override
  void initState() {
    getPref();
    _getBackupPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backup & Restore'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  'Back up your notes onto your device/Nextcloud. You can restore the, when you reinstall BNotes',
                  style: TextStyle(height: 1.5),
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Use Nextcloud'),
                trailing: Switch(
                  value: isUploading,
                  onChanged: (value) {
                    setState(() {
                      isUploading = value;
                      print(isUploading);
                    });
                  },
                ),
              ),
              // Switch(
              //   value: isUploading,
              //   onChanged: (value){
              //     setState(() {
              //       isUploading=value;
              //       print(isUploading);
              //     });
              //   },
              //   activeTrackColor: Colors.lightGreenAccent,
              //   activeColor: Colors.green,
              // ),
              // Container(
              //   padding: EdgeInsets.all(20.0),
              //   child: Text('Path: $backupPath'),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _makeBackup();
                        Navigator.pop(context);
                      },
                      icon: Icon(CupertinoIcons.cloud_upload),
                      label: Text('Backup'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _restore();
                        Navigator.pop(context);
                      },
                      icon: Icon(CupertinoIcons.cloud_download),
                      label: Text('Restore'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
