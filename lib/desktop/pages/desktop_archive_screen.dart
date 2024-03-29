import 'package:flutter/material.dart';

class DesktopArchiveScreen extends StatefulWidget {
  const DesktopArchiveScreen({super.key});

  @override
  State<DesktopArchiveScreen> createState() => _DesktopArchiveScreenState();
}

class _DesktopArchiveScreenState extends State<DesktopArchiveScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Archive'),
      ),
    );
  }
}
