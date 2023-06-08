import 'package:bnotes/common/string_values.dart';
import 'package:flutter/material.dart';

class DesktopTasksScreen extends StatefulWidget {
  const DesktopTasksScreen({Key? key}) : super(key: key);

  @override
  State<DesktopTasksScreen> createState() => _DesktopTasksScreenState();
}

class _DesktopTasksScreenState extends State<DesktopTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kLabels['notes']!),
      ),
      body: const Center(
        child: Text('All Tasks'),
      ),
    );
  }
}
