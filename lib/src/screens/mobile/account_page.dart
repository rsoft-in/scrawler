import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/screens/mobile/apperance_page.dart';

import '../../helpers/globals.dart' as globals;

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List menu = [
    {
      'title': 'Appearance',
      'page': AppearancePage(),
      'icon': Symbols.dark_mode
    },
    // {
    //   'title': 'Notification',
    //   'page': 'notification',
    //   'icon': Symbols.notifications
    // },
    {'title': 'About', 'page': Container(), 'icon': Symbols.info},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 16.0,
              children: [
                CircleAvatar(
                  child: Icon(Symbols.person),
                ),
                Text('welcome_message'
                    .tr(namedArgs: {'name': globals.user.userName})),
              ],
            ),
            floating: true,
            snap: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Material(
                  type: MaterialType.card,
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        child: Icon(menu[index]['icon'])),
                    title: Text(menu[index]['title']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => menu[index]['page'],
                        ),
                      );
                    },
                  ),
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
