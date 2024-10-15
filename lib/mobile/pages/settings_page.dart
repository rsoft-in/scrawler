import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List menu = [
    {'title': 'Appearance', 'page': 'appearance', 'icon': Symbols.dark_mode},
    // {
    //   'title': 'Notification',
    //   'page': 'notification',
    //   'icon': Symbols.notifications
    // },
    {'title': 'About', 'page': 'about', 'icon': Symbols.info},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            title: const Text('Settings'),
            centerTitle: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(menu[index]['icon']),
                  title: Text(menu[index]['title']),
                  onTap: () {
                    Navigator.pushNamed(context, '/${menu[index]['page']}');
                  },
                );
              },
              childCount: menu.length,
            ),
          ),
        ],
      ),
    );
  }
}
