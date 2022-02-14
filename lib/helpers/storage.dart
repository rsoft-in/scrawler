import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';

class Storage {
  Future<String> get localPath async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      print(dir);
      return dir!.path;
    } 
    
    else {
      final dir = await getApplicationDocumentsDirectory();
      print(dir);
      print('is');
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
  Future<void> writeiOSData(String data) async{final file = await localFile;
if (UniversalPlatform.isIOS){
      await Share.shareFiles(['$file']);
      return null;
    }
  }
}
