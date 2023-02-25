import 'package:flutter/material.dart';

class DSettingsPage extends StatefulWidget {
  const DSettingsPage({Key? key}) : super(key: key);

  @override
  State<DSettingsPage> createState() => D_SettingsStatePage();
}

// ignore: camel_case_types
class D_SettingsStatePage extends State<DSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Settings'),
      ),
    );
  }
}
