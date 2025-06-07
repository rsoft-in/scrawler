import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/helpers/theme.dart';
import 'package:scrawler/src/helpers/theme_notifier.dart';
import 'package:scrawler/src/screens/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

import 'src/helpers/globals.dart' as globals;

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (_) => ThemeNotifier(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;
  int themeID = 3;

  Future<void> setAPIServer() async {
    try {
      String server = await rootBundle.loadString('res/apiserver');
      globals.apiServer = server;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setAPIServer();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: kAppName,
          themeMode: themeNotifier.themeMode,
          theme: theme(context, themeNotifier.selectedPrimaryColor),
          darkTheme: themeDark(context, themeNotifier.selectedPrimaryColor),
          debugShowCheckedModeBanner: false,
          home: WebSignIn(),
        );
      },
    );
  }
}
