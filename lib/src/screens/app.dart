import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:scrawler/src/helpers/adaptive.dart';
import 'package:scrawler/src/helpers/utility.dart';
import 'package:scrawler/src/screens/account_page.dart';
import 'package:scrawler/src/screens/notes_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int selectedIndex = 0;
  List<String> navRailTitles = ['notes'.tr(), 'account'.tr()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallDevice = getScreenSize(context) == ScreenSize.small;

    return FScaffold(
      sidebar: isSmallDevice
          ? null
          : FSidebar(
              children: [
                FSidebarItem(
                  icon: Icon(FIcons.notepadText),
                  label: Text('Notes'),
                  onPress: () => setState(() => selectedIndex = 0),
                ),
                FSidebarItem(
                  icon: Icon(FIcons.user),
                  label: Text('Account'),
                  onPress: () => setState(() => selectedIndex = 1),
                ),
              ],
            ),
      footer: isSmallDevice
          ? FBottomNavigationBar(
              index: selectedIndex,
              onChange: (index) => setState(() => selectedIndex = index),
              children: [
                FBottomNavigationBarItem(
                  icon: Icon(FIcons.notepadText),
                  label: const Text('Notes'),
                ),
                FBottomNavigationBarItem(
                  icon: Icon(FIcons.user),
                  label: const Text('Account'),
                ),
              ],
            )
          : null,
      child: PageTransitionSwitcher(
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
    );
  }
}
