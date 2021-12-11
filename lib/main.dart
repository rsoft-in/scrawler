import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bnotes/constants.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/pages/app.dart';
import 'package:bnotes/pages/app_lock_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (UniversalPlatform.isDesktop) {
    doWhenWindowReady(() {
      final initialSize = Size(900, 700);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
      appWindow.title = "scrawl";
    });
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;
  @override
  Widget build(BuildContext context) {
    const FlexScheme usedScheme = FlexScheme.blueWhale;

    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      // theme: theme(),
      // darkTheme: themeDark(),
      theme: FlexThemeData.light(
        scheme: usedScheme,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        // We set the blend level strength to 20.
        blendLevel: 40,
        // appBarElevation: 0.5,
        appBarOpacity: 0.5,
        appBarStyle: FlexAppBarStyle.surface,
        useSubThemes: true,
        transparentStatusBar: true,

        subThemesData: FlexSubThemesData(
          elevatedButtonRadius: 25.0,
          textButtonRadius: 25.0,
          outlinedButtonRadius: 25.0,
          cardRadius: 10.0,
          bottomNavigationBarOpacity: 0.5,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ),
      // The Mandy red, dark theme.
      darkTheme: FlexThemeData.dark(
        scheme: usedScheme,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurfaces,
        // You don't have to use same blend level or mode in light
        // and dark mode, here we use a lower value in dark mode, that
        // goes better together with the highScaffoldLowSurfaces mode.
        blendLevel: 25,
        appBarOpacity: 0.5,
        appBarStyle: FlexAppBarStyle.surface,
        useSubThemes: true,
        transparentStatusBar: true,
        subThemesData: FlexSubThemesData(
          elevatedButtonRadius: 25.0,
          textButtonRadius: 25.0,
          outlinedButtonRadius: 25.0,
          cardRadius: 10.0,
          bottomNavigationBarOpacity: 0.5,
          inputDecoratorBorderType: FlexInputBorderType.outline,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ),
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late SharedPreferences prefs;
  bool isAppUnlocked = false;
  bool isPinRequired = false;

  getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isAppUnlocked = prefs.getBool("is_app_unlocked") ?? false;
      isPinRequired = prefs.getBool("is_pin_required") ?? false;
      print(isAppUnlocked);
      print(isPinRequired);
      if (isPinRequired) {
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new AppLockPage(appLockState: AppLockState.CONFIRM),
            ),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(
                builder: (BuildContext context) => new ScrawlApp()),
            (Route<dynamic> route) => false);
      }
    });
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
