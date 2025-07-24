import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:scrawler/src/screens/about_page.dart';
import 'package:scrawler/src/screens/appearance_page.dart';

import '../helpers/globals.dart' as globals;

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List menu = [
    {'title': 'appearance'.tr(), 'page': AppearancePage(), 'icon': FIcons.moon},
    {'title': 'about'.tr(), 'page': AboutPage(), 'icon': FIcons.info},
  ];
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: FHeader(
          title: Text(globals.user.userName),
        ),
      ),
      childPad: false,
      child: SingleChildScrollView(
        child: FTileGroup(
          children: menu
              .map((mnu) => FTile(
                    prefix: Icon(mnu['icon']),
                    title: Text(mnu['title']),
                    suffix: Icon(FIcons.chevronRight),
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => mnu['page'],
                        ),
                      );
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
