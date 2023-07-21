import 'package:bnotes/models/label.dart';
import 'package:bnotes/models/notes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  late Database db;
  static const _databaseName = 'bnotes.s3db';
  static const _databaseVersion = 2;
  static const _databaseOldVersion = 1;
  Database? _database;

  DBHelper._privateConstructor();

  static final DBHelper instance = DBHelper._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await db.execute('''
                  CREATE TABLE notes (
                    note_id text primary key,
                    note_date text,
                    note_title text,
                    note_text text,
                    note_label text,
                    note_archived integer,
                    note_color integer,
                    note_image text,
                    note_audio_file text)
                ''');
        await db.execute('''
                  CREATE TABLE labels (label_id text primary key, label_name text)
                ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion == 1 && newVersion == 2) {
          db.execute('''ALTER TABLE notes DROP COLUMN note_list''');
          db.execute('''ALTER TABLE notes ADD COLUMN note_image text''');
          db.execute('''ALTER TABLE notes ADD COLUMN note_audio_file text''');
        }
      },
    );
  }

  Future<List<Notes>> getNotesAll(String filter, String sortBy) async {
    Database? db = await instance.database;
    var parsed = await db!.query('notes',
        orderBy: sortBy,
        where:
            'note_archived = 0 ${filter.isNotEmpty ? ' AND (note_title LIKE \'%$filter%\' OR note_text LIKE \'%$filter%\' OR note_label LIKE \'%$filter%\')' : ''}');
    return parsed.map<Notes>((json) => Notes.fromJson(json)).toList();
  }

  Future<List<Notes>> getNotesArchived(String filter) async {
    Database? db = await instance.database;
    var parsed = await db!.query('notes',
        orderBy: 'note_date DESC',
        where:
            'note_archived = 1 ${filter.isNotEmpty ? ' AND (note_title LIKE \'%$filter%\' OR note_text LIKE \'%$filter%\' OR note_label LIKE \'%$filter%\')' : ''}');
    return parsed.map<Notes>((json) => Notes.fromJson(json)).toList();
  }

  Future<bool> archiveNote(String noteId, int archive) async {
    Database? db = await instance.database;
    Map<String, dynamic> map = {'note_id': noteId, 'note_archived': archive};
    String id = map['note_id'];
    final rowsAffected =
        await db!.update('notes', map, where: 'note_id = ?', whereArgs: [id]);
    return (rowsAffected == 1);
  }

  Future<bool> insertNotes(Notes note) async {
    Database? db = await instance.database;
    await db!.insert('notes', note.toJson());
    return true;
  }

  Future<bool> updateNotes(Notes note) async {
    Database? db = await instance.database;
    Map<String, dynamic> map = {
      'note_id': note.noteId,
      'note_date': note.noteDate,
      'note_title': note.noteTitle,
      'note_text': note.noteText
    };
    String id = map['note_id'];
    final rowsAffected =
        await db!.update('notes', map, where: 'note_id = ?', whereArgs: [id]);
    return (rowsAffected == 1);
  }

  Future<bool> updateNoteColor(String noteId, int noteColor) async {
    Database? db = await instance.database;
    Map<String, dynamic> map = {'note_id': noteId, 'note_color': noteColor};
    String id = map['note_id'];
    final rowsAffected =
        await db!.update('notes', map, where: 'note_id = ?', whereArgs: [id]);
    return (rowsAffected == 1);
  }

  Future<bool> updateNoteLabel(String noteId, String noteLabel) async {
    Database? db = await instance.database;
    Map<String, dynamic> map = {'note_id': noteId, 'note_label': noteLabel};
    String id = map['note_id'];
    final rowsAffected =
        await db!.update('notes', map, where: 'note_id = ?', whereArgs: [id]);
    return (rowsAffected == 1);
  }

  Future<bool> deleteNotes(String noteId) async {
    Database? db = await instance.database;
    int rowsAffected =
        await db!.delete('notes', where: 'note_id = ?', whereArgs: [noteId]);
    return (rowsAffected == 1);
  }

  Future<List<Label>> getLabelsAll() async {
    Database? db = await instance.database;
    var parsed = await db!.query('labels', orderBy: 'label_name');
    print(parsed);
    return parsed.map<Label>((json) => Label.fromJson(json)).toList();
  }

  Future<bool> insertLabel(Label label) async {
    Database? db = await instance.database;
    int rowsAffected = await db!.insert('labels', label.toJson());
    return (rowsAffected >= 0);
  }

  Future<bool> updateLabel(Label label) async {
    Database? db = await instance.database;
    Map<String, dynamic> map = {
      'label_id': label.labelId,
      'label_name': label.labelName
    };
    String id = map['label_id'];
    final rowsAffected =
        await db!.update('labels', map, where: 'label_id = ?', whereArgs: [id]);
    return (rowsAffected == 1);
  }

  Future<bool> deleteLabel(String labelId) async {
    Database? db = await instance.database;
    int rowsAffected =
        await db!.delete('labels', where: 'label_id = ?', whereArgs: [labelId]);
    return (rowsAffected == 1);
  }
}
