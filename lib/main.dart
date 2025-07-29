import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/helpers/theme_notifier.dart';
import 'package:scrawler/src/screens/signin.dart';
import 'package:scrawler/src/widgets/rs_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/helpers/globals.dart' as globals;

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ChangeNotifierProvider(
          create: (_) => ThemeNotifier(), child: MyApp()),
    ),
  );
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
        RSToast.show(context, message: '$e');
      }
    }
  }

  Future<void> getSecretKey() async {
    try {
      String key = await rootBundle.loadString('res/secretkey');
      globals.secretKey = key;
    } catch (e) {
      if (mounted) {
        RSToast.show(context, message: '$e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setAPIServer();
    getSecretKey();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: kAppName,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) =>
              FTheme(data: FThemes.zinc.light, child: child!),
          debugShowCheckedModeBanner: false,
          home: SignIn(),
        );
      },
    );
  }
}
