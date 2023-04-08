import 'package:flutter/material.dart';

class DesktopSearchScreen extends StatefulWidget {
  const DesktopSearchScreen({Key? key}) : super(key: key);

  @override
  State<DesktopSearchScreen> createState() => _DesktopSearchScreenState();
}

class _DesktopSearchScreenState extends State<DesktopSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Search'),
      ),
    );
  }
}
