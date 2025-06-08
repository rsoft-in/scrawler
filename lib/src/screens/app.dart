import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/screens/notes_page.dart';
import 'package:scrawler/src/screens/settings_page.dart';

import '../helpers/globals.dart' as globals;

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello ${globals.user.userName}'),
        actionsPadding: EdgeInsets.only(right: 8.0),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Symbols.person,
            ),
          ),
        ],
      ),
      body: [NotesPage(), SettingsPage()][selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        destinations: [
          NavigationDestination(icon: Icon(Symbols.note), label: 'Notes'),
          NavigationDestination(
              icon: Icon(Symbols.settings), label: 'Settings'),
        ],
        onDestinationSelected: (value) => setState(() {
          selectedIndex = value;
        }),
      ),
    );
  }
}
