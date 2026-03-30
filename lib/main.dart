import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/helpers/theme.dart';
import 'package:scrawler/src/helpers/theme_notifier.dart';
import 'package:scrawler/src/providers/backup_service.dart';
import 'package:scrawler/src/providers/notes_provider.dart';
import 'package:scrawler/src/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeNotifier()),
          // Initialize NoteProvider and immediately fetch data from SQLite
          ChangeNotifierProvider(create: (_) => NoteProvider()..fetchNotes()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
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
          debugShowCheckedModeBanner: false,
          themeMode: themeNotifier.themeMode,
          theme: theme(context, themeNotifier.selectedPrimaryColor),
          darkTheme: themeDark(context, themeNotifier.selectedPrimaryColor),
          home: HomePage(),
        );
      },
    );
  }
}
