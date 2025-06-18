import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/helpers/adaptive.dart';
import 'package:scrawler/src/helpers/utility.dart';
import 'package:scrawler/src/screens/account_page.dart';
import 'package:scrawler/src/screens/notes_page.dart';

import '../helpers/globals.dart' as globals;

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int selectedIndex = 0;
  List<String> navRailTitles = ['notes'.tr(), 'account'.tr()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallDevice = getScreenSize(context) == ScreenSize.small;
    final Widget navRail = NavigationRail(
      destinations: <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(Symbols.note),
          label: Text('notes'.tr()),
        ),
        NavigationRailDestination(
          icon: Icon(Symbols.person),
          label: Text('account'.tr()),
        ),
      ],
      selectedIndex: selectedIndex,
      labelType: NavigationRailLabelType.all,
      onDestinationSelected: (value) => setState(() {
        selectedIndex = value;
      }),
    );
    final Widget navBar = NavigationBar(
      selectedIndex: selectedIndex,
      destinations: [
        NavigationDestination(icon: Icon(Symbols.note), label: 'notes'.tr()),
        NavigationDestination(
            icon: Icon(Symbols.person), label: 'account'.tr()),
      ],
      onDestinationSelected: (value) => setState(() {
        selectedIndex = value;
      }),
    );
    return isSmallDevice
        ? Scaffold(
            appBar: AppBar(
              title: Text('welcome_message'
                  .tr(namedArgs: {'name': globals.user.userName})),
            ),
            body: [NotesPage(), AccountPage()][selectedIndex],
            bottomNavigationBar: navBar,
          )
        : Scaffold(
            body: Row(
              children: [
                navRail,
                VerticalDivider(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AppBar(
                        title: Text(navRailTitles[selectedIndex]),
                      ),
                      Expanded(
                        child: [NotesPage(), AccountPage()][selectedIndex],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
