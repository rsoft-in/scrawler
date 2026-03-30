import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:scrawler/src/helpers/dbhelper.dart';

class BackupService {
  final String
  nextcloudUrl; // e.g., "https://yourcloud.com/remote.php/dav/files/user/"
  final String username;
  final String
  password; // Use an "App Password" from Nextcloud security settings

  BackupService({
    required this.nextcloudUrl,
    required this.username,
    required this.password,
  });

  Future<Map<String, dynamic>> backupToJson() async {
    final allNotes = await DatabaseHelper.instance.queryAll();
    String jsonContent = jsonEncode(allNotes);

    final fileName = "scrawler_backup.json";
    final uploadUrl = Uri.parse("$nextcloudUrl/$fileName");

    String auth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    try {
      final response = await http.put(
        uploadUrl,
        headers: {'Authorization': auth, 'Content-Type': 'application/json'},
        body: jsonContent,
      );

      if (response.statusCode == 201 || response.statusCode == 204) {
        return {"status": true, "error": ""};
      } else {
        return {
          "status": false,
          "error": "${'failed_to_upload'.tr()}: ${response.statusCode}",
        };
      }
    } catch (e) {
      return {"status": false, "error": "$e"};
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
