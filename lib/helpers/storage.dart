import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<String> get localPath async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      print(dir);
      return dir.path;
    } else {
      final dir = await getApplicationDocumentsDirectory();
      print(dir);
      return dir.path;
    }
  }

  Future<File> get localFile async {
    final path = await localPath;
    print(path);
    return File('$path/bnotes.backup');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }
}
