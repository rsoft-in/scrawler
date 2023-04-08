import 'package:flutter/material.dart';

class DesktopSettingsScreen extends StatefulWidget {
  const DesktopSettingsScreen({Key? key}) : super(key: key);

  @override
  State<DesktopSettingsScreen> createState() => D_SettingsStatePage();
}

// ignore: camel_case_types
class D_SettingsStatePage extends State<DesktopSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Settings'),
      ),
    );
  }
}
