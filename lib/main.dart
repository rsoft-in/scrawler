import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:scrawler/desktop/desktop_app.dart';
import 'package:scrawler/desktop/pages/web_signin.dart';
import 'package:scrawler/desktop/theme.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/helpers/theme_notifier.dart';
import 'package:scrawler/mobile/mobile_app.dart';
import 'package:scrawler/mobile/pages/about_page.dart';
import 'package:scrawler/mobile/pages/appearance_page.dart';
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
    WindowOptions windowOptions = WindowOptions(
      size: const Size(1000, 650),
      minimumSize: const Size(500, 500),
      center: true,
      skipTaskbar: false,
      titleBarStyle: UniversalPlatform.isWindows
          ? TitleBarStyle.hidden
          : TitleBarStyle.normal,
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

  runApp(ChangeNotifierProvider(
      create: (_) => ThemeNotifier(), child: const MyApp()));
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
        home: UniversalPlatform.isWeb
            ? const WebSignIn()
            : Column(
                children: [
                  Material(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onPanStart: (details) {
                        windowManager.startDragging();
                      },
                      onDoubleTap: () async {
                        bool isMaximized = await windowManager.isMaximized();
                        if (!isMaximized) {
                          windowManager.maximize();
                        } else {
                          windowManager.unmaximize();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(kAppName),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                windowManager.minimize();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Icon(
                                  Symbols.minimize,
                                  size: 16,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                bool isMaximized =
                                    await windowManager.isMaximized();
                                if (!isMaximized) {
                                  windowManager.maximize();
                                } else {
                                  windowManager.unmaximize();
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Icon(
                                  Symbols.square_rounded,
                                  size: 16,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                windowManager.close();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Icon(
                                  Symbols.close,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Expanded(child: DesktopApp()),
                ],
              ),
      );
    } else {
      return Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: kAppName,
            themeMode: themeNotifier.themeMode,
            theme: theme(context),
            darkTheme: themeDark(context),
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => MobileApp(),
              '/appearance': (context) => AppearancePage(),
              '/about': (context) => AboutPage(),
            },
          );
        },
      );
    }
  }
}
