import 'dart:convert';
import 'dart:io';

import 'package:bnotes/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';

import '../../helpers/dbhelper.dart';
import '../../models/notes.dart';

class BackupRestorePageMaterial extends StatefulWidget {
  const BackupRestorePageMaterial({super.key});

  @override
  State<BackupRestorePageMaterial> createState() =>
      _BackupRestorePageMaterialState();
}

class _BackupRestorePageMaterialState extends State<BackupRestorePageMaterial> {
  DBHelper dbHelper = DBHelper.instance;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Symbols.download),
            title: const Text('Backup to Local'),
            onTap: () => backupNotes(),
          ),
          ListTile(
            leading: const Icon(Symbols.upload),
            title: const Text('Restore from local backup'),
            onTap: () => restoreNotes(),
          ),
        ],
      ),
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> backupNotes() async {
    final path = await _localPath;
    final file = File('$path/scrawler.bak');
    final notes = await dbHelper.getNotesAll('', 'note_title');
    file.writeAsString(jsonEncode(notes));
    // ignore: use_build_context_synchronously
    fToast.showToast(child: const ScrawlToast('Backup Done!'));
  }

  Future<void> restoreNotes() async {
    final path = await _localPath;
    final file = File('$path/scrawler.bak');
    final bak = await file.readAsString();
    await dbHelper.deleteNotesAll();
    final parsed = json.decode(bak);
    List<Notes> notes =
        parsed.map<Notes>((json) => Notes.fromJson(json)).toList();
    int notesRestored = 0;
    for (var note in notes) {
      final result = await dbHelper.insertNotes(note);
      if (result) notesRestored++;
    }
    fToast.showToast(child: ScrawlToast('$notesRestored Notes restored'));
  }
}
