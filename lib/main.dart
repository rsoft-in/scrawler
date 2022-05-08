import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bnotes/common/constants.dart';
import 'package:bnotes/desktop/app.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/pages/app.dart';
import 'package:bnotes/pages/app_lock_page.dart';
import 'package:bnotes/pages/introduction_page.dart';
import 'package:bnotes/common/theme.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

import 'pages/biometric_page.dart';
import 'helpers/globals.dart' as globals;

late SharedPreferences prefs;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (UniversalPlatform.isDesktop) {
    doWhenWindowReady(() {
      final initialSize = Size(1000, 650);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
      appWindow.title = "scrawl";
    });
  }
  runApp(Phoenix(
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;
  int themeID = 3;

  @override
  void initState() {
    getprefs();
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
      theme: theme(),
      darkTheme: themeDark(),
      home: UniversalPlatform.isDesktopOrWeb ? ScrawlDesktop() : StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isAppUnlocked = false;
  bool isPinRequired = false;
  bool useBiometric = false;
  bool newUser = true;

  getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isAppUnlocked = prefs.getBool("is_app_unlocked") ?? false;
      isPinRequired = prefs.getBool("is_pin_required") ?? false;
      useBiometric = prefs.getBool('use_biometric') ?? false;
      newUser = prefs.getBool('newUser') ?? true;

      if (isPinRequired) {
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new AppLockPage(appLockState: AppLockState.CONFIRM),
            ),
            (Route<dynamic> route) => false);
      } else if (useBiometric) {
        confirmBiometrics();
      } else {
        if (newUser) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(
                builder: (BuildContext context) => new IntroductionPage(),
              ),
              (Route<dynamic> route) => false);
        } else
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new ScrawlApp()),
              (Route<dynamic> route) => false);
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  void confirmBiometrics() async {
    bool res = await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new BiometricPage()));
    if (res)
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
            builder: (BuildContext context) => new ScrawlApp(),
          ),
          (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
