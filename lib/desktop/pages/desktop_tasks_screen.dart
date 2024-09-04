import 'package:flutter/material.dart';
import 'package:scrawler/helpers/string_values.dart';

class DesktopTasksScreen extends StatefulWidget {
  const DesktopTasksScreen({super.key});

  @override
  State<DesktopTasksScreen> createState() => _DesktopTasksScreenState();
}

class _DesktopTasksScreenState extends State<DesktopTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kLabels['tasks']!),
      ),
      body: const Center(
        child: Text('Coming Soon'),
      ),
    );
  }
}
