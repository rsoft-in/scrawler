import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

class Win_Settings_Page extends StatefulWidget {
  const Win_Settings_Page({super.key});

  @override
  State<Win_Settings_Page> createState() => _Win_Settings_PageState();
}

class _Win_Settings_PageState extends State<Win_Settings_Page> {
  @override
  Widget build(BuildContext context) {
    return fluent.ScaffoldPage(
      content: fluent.ListView(
        children: [
          fluent.ListTile.selectable(
            title: const Text('Version'),
            subtitle: const Text('2.0 - Angelfish'),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
