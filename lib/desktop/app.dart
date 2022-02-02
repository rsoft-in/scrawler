import 'package:animations/animations.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bnotes/constants.dart';
import 'package:bnotes/desktop/pages/archive_page.dart';
import 'package:bnotes/desktop/pages/home_page.dart';
import 'package:bnotes/desktop/pages/search_page.dart';
import 'package:bnotes/desktop/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:yaru_icons/widgets/yaru_icons.dart';

class ScrawlDesktop extends StatefulWidget {
  const ScrawlDesktop({Key? key}) : super(key: key);

  @override
  _ScrawlDesktopState createState() => _ScrawlDesktopState();
}

class _ScrawlDesktopState extends State<ScrawlDesktop> {
  final _pageList = <Widget>[
    new DHomePage(),
    new DArchivePage(),
    new DSearchPage(),
    new DSettingsPage(),
  ];
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 56),
        child: WindowTopBar(),
      ),
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              child: SideNavigationBar(
                initiallyExpanded: false,
                toggler: SideBarToggler(
                  expandIcon: Iconsax.arrow_right_3,
                  shrinkIcon: Iconsax.arrow_left_2,
                ),
                theme: SideNavigationBarTheme(
                    backgroundColor: null,
                    showMainDivider: false,
                    itemTheme: ItemTheme(selectedItemColor: kPrimaryColor),
                    showFooterDivider: false,
                    showHeaderDivider: false,
                    togglerTheme: TogglerTheme()),
                items: [
                  SideNavigationBarItem(
                    icon: Iconsax.note,
                    label: 'Notes',
                  ),
                  SideNavigationBarItem(
                    icon: Iconsax.archive,
                    label: 'Archive',
                  ),
                  SideNavigationBarItem(
                    icon: Iconsax.search_normal,
                    label: 'Search',
                  ),
                  SideNavigationBarItem(
                    icon: Iconsax.menu,
                    label: 'Menu',
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _page = index;
                  });
                },
                selectedIndex: _page,
              ),
            ),
          ),
          Expanded(
            child: PageTransitionSwitcher(
              transitionBuilder: (child, animation, secondaryAnimation) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              child: _pageList[_page],
            ),
          ),
        ],
      ),
    );
  }
}

class WindowTopBar extends StatelessWidget {
  const WindowTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: WindowTitleBarBox(
          child: Row(
            children: [
              WindowButtons(),
              Expanded(child: MoveWindow()),
            ],
          ),
        ),
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        WindowIconButtons(
          icon: Icon(
            YaruIcons.window_close,
            size: 16,
          ),
          ontap: () {
            appWindow.close();
          },
        ),
        WindowIconButtons(
          icon: Icon(
            YaruIcons.window_minimize,
            size: 16,
          ),
          ontap: () {
            appWindow.minimize();
          },
        ),
        WindowIconButtons(
          icon: Icon(
            YaruIcons.window_maximize,
            size: 16,
          ),
          ontap: () {
            appWindow.maximizeOrRestore();
          },
        ),
      ],
    );
  }
}

class WindowIconButtons extends StatefulWidget {
  final Icon icon;
  final Function ontap;
  const WindowIconButtons({Key? key, required this.icon, required this.ontap})
      : super(key: key);

  @override
  State<WindowIconButtons> createState() => _WindowIconButtonsState();
}

class _WindowIconButtonsState extends State<WindowIconButtons> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: () => widget.ontap(),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: darkModeOn
                ? Colors.grey.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}
