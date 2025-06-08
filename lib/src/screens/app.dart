import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../helpers/globals.dart' as globals;

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello ${globals.user.userName}'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Symbols.person,
            ),
          ),
        ],
      ),
    );
  }
}
