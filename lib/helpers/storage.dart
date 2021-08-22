import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<String> get localPath async {
    if (Platform.isAndroid || Platform.isIOS) {
      final dir = await getExternalStorageDirectory();
      print(dir);
      return dir!.path;
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
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path.toString());
        //final file = await localFile;
        String body = await file.readAsString();
        return body;
      } else {
        return '';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }
}
