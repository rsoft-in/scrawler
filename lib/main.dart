import 'package:bnotes/constants.dart';
import 'package:bnotes/pages/app.dart';
import 'package:bnotes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: theme(),
      darkTheme: themeDark(),
      home: ScrawlApp(),
    );
  }
}
