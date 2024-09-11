import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/linux/linux_app.dart';
import 'package:scrawler/linux/theme.dart';
import 'package:scrawler/windows/windows_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

import 'helpers/globals.dart' as globals;

late SharedPreferences prefs;
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

    // if (UniversalPlatform.isIOS) {
    //   return CupertinoApp(
    //     title: kAppName,
    //     debugShowCheckedModeBanner: false,
    //     initialRoute: '/',
    //     routes: {
    //       '/': (context) => UniversalPlatform.isIOS
    //           ? const DashCupertino()
    //           : const DashMaterial(),
    //     },
    //   );
    // } else {
    //   return MaterialApp(
    //     title: kAppName,
    //     debugShowCheckedModeBanner: false,
    //     themeMode: globals.themeMode,
    //     theme: theme(),
    //     darkTheme: themeDark(),
    //     routes: {
    //       '/': (context) =>
    //           (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
    //               ? const DashMaterial()
    //               : const DesktopLanding(),
    //       '/dsignin': (context) => const DesktopSignIn(),
    //       '/dsignup': (context) => const DesktopSignUp(),
    //       '/mobilestart': (context) => const DashMaterial()
    //     },
    //     initialRoute: '/',
    //   );
    // }
    if (UniversalPlatform.isWindows) {
      return fluent.FluentApp(
        title: kAppName,
        darkTheme: fluent.FluentThemeData(
          brightness: Brightness.dark,
          accentColor: fluent.Colors.red,
          visualDensity: VisualDensity.standard,
          focusTheme: fluent.FocusThemeData(
            glowFactor: fluent.is10footScreen(context) ? 2.0 : 0.0,
          ),
        ),
        theme: fluent.FluentThemeData(
          accentColor: fluent.Colors.blue,
          visualDensity: VisualDensity.standard,
          focusTheme: fluent.FocusThemeData(
            glowFactor: fluent.is10footScreen(context) ? 2.0 : 0.0,
          ),
        ),
        home: const WindowsApp(),
      );
    } else if (UniversalPlatform.isLinux) {
      return MaterialApp(
        title: kAppName,
        theme: theme,
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        home: const LinuxApp(),
      );
    } else {
      return const MaterialApp();
    }
  }
}
