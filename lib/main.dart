import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/language.dart';
import 'package:bnotes/helpers/theme.dart';
import 'package:bnotes/desktop/desktop_landing.dart';
import 'package:bnotes/desktop/pages/desktop_sign_in.dart';
import 'package:bnotes/desktop/pages/desktop_sign_up.dart';
import 'package:bnotes/mobile/pages/mobile_start_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

import 'helpers/globals.dart' as globals;

late SharedPreferences prefs;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (UniversalPlatform.isDesktop) {
    doWhenWindowReady(() {
      const initialSize = Size(1000, 650);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
      appWindow.title = "scrawler";
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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
    Language.readJson();

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
            themeMode = ThemeMode.light;
            break;
        }
      } else {
        themeMode = ThemeMode.system;
        prefs.setInt('themeMode', 2);
      }
      globals.themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      // themeMode: ThemeMode.light,
      theme: theme(),
      darkTheme: themeDark(),
      routes: {
        '/': (context) => UniversalPlatform.isDesktopOrWeb || kIsWeb
            ? const DesktopLanding()
            : const MobileStartPage(),
        '/dsignin': (context) => const DesktopSignIn(),
        '/dsignup': (context) => const DesktopSignUp(),
        '/mobilestart': (context) => const MobileStartPage()
      },
      initialRoute: '/',
    );
  }
}
