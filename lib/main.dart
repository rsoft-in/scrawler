import 'package:bnotes/desktop_web/desktop_landing.dart';
import 'package:bnotes/desktop_web/desktop_sign_in.dart';
import 'package:bnotes/desktop_web/desktop_sign_up.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/theme.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/mobile/cupertino/dash_cupertino.dart';
import 'package:bnotes/mobile/material/dash_material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

import 'helpers/globals.dart' as globals;

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (UniversalPlatform.isDesktop) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1000, 650),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;
  int themeID = 3;
  bool isDesktopOrWeb = false;
  ScreenSize _screenSize = ScreenSize.large;

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
            themeMode = ThemeMode.dark;
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
    _screenSize = getScreenSize(context);
    if ((_screenSize == ScreenSize.large || UniversalPlatform.isWeb) ||
        UniversalPlatform.isDesktop) isDesktopOrWeb = true;
    if (UniversalPlatform.isIOS) {
      return CupertinoApp(
        title: kAppName,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => UniversalPlatform.isIOS
              ? const DashCupertino()
              : const DashMaterial(),
        },
      );
    } else {
      return MaterialApp(
        title: kAppName,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: theme(),
        darkTheme: themeDark(),
        routes: {
          '/': (context) =>
              isDesktopOrWeb ? const DesktopLanding() : const DashMaterial(),
          '/dsignin': (context) => const DesktopSignIn(),
          '/dsignup': (context) => const DesktopSignUp(),
          '/mobilestart': (context) => const DashMaterial()
        },
        initialRoute: '/',
      );
    }
  }
}
