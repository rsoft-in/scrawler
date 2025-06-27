import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/helpers/adaptive.dart';
import 'package:scrawler/src/helpers/utility.dart';
import 'package:scrawler/src/models/notes.dart';
import 'package:scrawler/src/screens/desktop/notes_page.dart';
import 'package:scrawler/src/screens/mobile/account_page.dart';

import '../../helpers/globals.dart' as globals;

class AppDesktop extends StatefulWidget {
  const AppDesktop({super.key});

  @override
  State<AppDesktop> createState() => _AppDesktopState();
}

class _AppDesktopState extends State<AppDesktop> {
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
          icon: Icon(Symbols.note_stack),
          selectedIcon: Icon(Symbols.note_stack),
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
        NavigationDestination(
          icon: Icon(Symbols.note_stack),
          selectedIcon: Icon(
            Symbols.note_stack,
            fill: 1,
          ),
          label: 'notes'.tr(),
        ),
        NavigationDestination(
          icon: Icon(Symbols.person),
          selectedIcon: Icon(
            Symbols.person,
            fill: 1,
          ),
          label: 'account'.tr(),
        ),
      ],
      onDestinationSelected: (value) => setState(() {
        selectedIndex = value;
      }),
    );
    return isSmallDevice
        ? Scaffold(
            body: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (
                Widget child,
                Animation<double> primaryAnimation,
                Animation<double> secondaryAnimation,
              ) {
                return FadeTransition(
                  opacity: primaryAnimation,
                  child: ScaleTransition(
                    filterQuality: FilterQuality.high,
                    scale: Tween<double>(
                      begin: 0.99,
                      end: 1.0,
                    ).animate(primaryAnimation),
                    child: child,
                  ),
                );
              },
              child: [NotesPage(), AccountPage()][selectedIndex],
            ),
            bottomNavigationBar: navBar,
          )
        : Scaffold(
            body: Row(
              children: [
                navRail,
                VerticalDivider(
                  thickness: 1,
                  width: 1,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 48,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: globals.openNotes.length,
                          itemBuilder: (context, index) {
                            if (index > 0) {
                              return ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  (globals.openNotes[index]['note'] as Notes)
                                      .noteTitle,
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
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
