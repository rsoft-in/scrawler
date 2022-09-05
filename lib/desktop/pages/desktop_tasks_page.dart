import 'package:flutter/material.dart';

class DesktopTasksPage extends StatefulWidget {
  const DesktopTasksPage({Key? key}) : super(key: key);

  @override
  State<DesktopTasksPage> createState() => _DesktopTasksPageState();
}

class _DesktopTasksPageState extends State<DesktopTasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('All Tasks'),
      ),
    );
  }
}
