import 'package:flutter/material.dart';

class DesktopNotesPage extends StatefulWidget {
  const DesktopNotesPage({Key? key}) : super(key: key);

  @override
  State<DesktopNotesPage> createState() => _DesktopNotesPageState();
}

class _DesktopNotesPageState extends State<DesktopNotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('All Notes'),
      ),
    );
  }
}
