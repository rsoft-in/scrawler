import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:scrawler/desktop/desktop_app.dart';
import 'package:scrawler/desktop/pages/web_signin.dart';
import 'package:scrawler/desktop/theme.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/mobile/mobile_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

import 'helpers/globals.dart' as globals;

late SharedPreferences prefs;

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig(
    toolbarStyle: NSWindowToolbarStyle.unified,
  );
  await config.apply();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (UniversalPlatform.isWindows ||
      UniversalPlatform.isLinux ||
      UniversalPlatform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  if (UniversalPlatform.isDesktop) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1000, 650),
      minimumSize: Size(500, 500),
      center: true,
      skipTaskbar: false,
      // titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      // if (Platform.isLinux) {
      //   windowManager.setAsFrameless();
      // }
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // ** Enable this ** //
  if (UniversalPlatform.isMacOS) await _configureMacosWindowUtils();

  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;
  int themeID = 3;

  @override
  void initState() {
    getprefs();

    // Load Language Resource into Memory
    // Language.readJson();

    super.initState();
  }

  getprefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getInt('themeMode') != null) {
        switch (prefs.getInt('themeMode')) {
          case 0:
            themeMode = ThemeMode.light;
            break;
          case 1:
            themeMode = ThemeMode.dark;
            break;
          case 2:
            themeMode = ThemeMode.system;
            break;
          default:
            themeMode = ThemeMode.system;
            break;
        }
      } else {
        themeMode = ThemeMode.light;
        prefs.setInt('themeMode', 0);
      }
      globals.themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isDesktop || UniversalPlatform.isWeb) {
      return MaterialApp(
        title: kAppName,
        theme: theme(context),
        darkTheme: themeDark(context),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: UniversalPlatform.isWeb ? const WebSignIn() : const DesktopApp(),
      );
    } else {
      return MaterialApp(
        title: kAppName,
        themeMode: ThemeMode.system,
        theme: theme(context),
        darkTheme: themeDark(context),
        home: const MobileApp(),
        debugShowCheckedModeBanner: false,
      );
    }
  }
}
