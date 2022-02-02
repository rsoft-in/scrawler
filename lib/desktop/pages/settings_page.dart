import 'package:flutter/material.dart';

class DSettingsPage extends StatefulWidget {
  const DSettingsPage({Key? key}) : super(key: key);

  @override
  D_SettingsStatePage createState() => D_SettingsStatePage();
}

class D_SettingsStatePage extends State<DSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Settings'),
      ),
    );
  }
}
