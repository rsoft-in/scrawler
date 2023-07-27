import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bnotes/desktop/pages/desktop_notes_screen.dart';
import 'package:bnotes/desktop/pages/desktop_profile_screen.dart';
import 'package:bnotes/desktop/pages/desktop_settings_screen.dart';
import 'package:bnotes/desktop/pages/desktop_tasks_screen.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:bnotes/helpers/string_values.dart';
import 'package:bnotes/widgets/scrawl_navrail.dart';
import 'package:bnotes/widgets/window_controls.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:yaru_icons/yaru_icons.dart';

class DesktopApp extends StatefulWidget {
  const DesktopApp({Key? key}) : super(key: key);

  @override
  State<DesktopApp> createState() => _DesktopAppState();
}

class _DesktopAppState extends State<DesktopApp> {
  final GlobalKey<ScaffoldState> _desktopKey = GlobalKey();

  late SharedPreferences prefs;
  bool isDesktop = false;
  List<Map<String, dynamic>> menu = [];
  String _selectedDrawerIndex = 'all_notes';
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.none;

  _onDrawerItemSelect(String menuId) {
    setState(() => _selectedDrawerIndex = menuId);
  }

  _getDrawerItemWidget(String menuId) {
    switch (menuId) {
      case 'all_notes':
        return const DesktopNotesScreen();
      case 'all_tasks':
        return const DesktopTasksScreen();
      default:
        return const Text("Error");
    }
  }

  @override
  void initState() {
    doWhenWindowReady(() {
      const initialSize = Size(1100, 700);
      appWindow.minSize = const Size(800, 700);
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
    super.initState();
    menu = kMenu;
  }

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));

    Widget drawer = SizedBox(
      width: 250,
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
              child: const Text(
                kAppName,
                style: TextStyle(fontSize: 26.0),
              ),
            ),
            // Menu Items
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: ListView(
                  children: [
                    ...List.generate(menu.length, (index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        child: ListTile(
                          selectedTileColor:
                              darkModeOn ? kDarkSelected : kLightSelected,
                          selectedColor: Colors.black,
                          leading: Container(
                            width: 35,
                            height: 35,
                            alignment: Alignment.center,
                            child: Icon(
                              menu[index]['icon'],
                            ),
                          ),
                          title: Text(kLabels[menu[index]['text']]!),
                          selected: menu[index]['id'] == _selectedDrawerIndex,
                          onTap: () {
                            _selectedIndex = index;
                            setState(() {});
                            _onDrawerItemSelect(menu[index]['id']);
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                leading: const CircleAvatar(
                  child: Icon(YaruIcons.user),
                ),
                title: Text(globals.user!.userName),
                onTap: () => showProfile(),
              ),
            )
          ],
        ),
      ),
    );

    // Widget navigationRail = NavigationRail(
    //   labelType: labelType,
    //   selectedIndex: _selectedIndex,
    //   onDestinationSelected: (int index) {
    //     setState(() {
    //       _selectedIndex = index;
    //       _onDrawerItemSelect(menu[index]['id']);
    //     });
    //   },
    //   leading: CircleAvatar(
    //     backgroundColor: Colors.transparent,
    //     child: Image.asset('images/bnotes-transparent.png'),
    //   ),
    //   destinations: <NavigationRailDestination>[
    //     ...List.generate(menu.length, (index) {
    //       return NavigationRailDestination(
    //         icon: Icon(
    //           menu[index]['icon'],
    //           size: 18.0,
    //           color: Color(menu[index]['color']),
    //         ),
    //         selectedIcon: Icon(
    //           menu[index]['icon'],
    //           size: 20.0,
    //           color: Color(menu[index]['color']),
    //         ),
    //         label: Text(menu[index]['text']),
    //       );
    //     }),
    //   ],
    //   trailing: IconButton(
    //     onPressed: () => showProfile(),
    //     icon: const Icon(
    //       BootstrapIcons.person,
    //       color: kPrimaryColor,
    //     ),
    //   ),
    // );

    return Scaffold(
      key: _desktopKey,
      drawer: drawer,
      backgroundColor: darkModeOn ? kDarkSecondary : kLightSecondary,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: darkModeOn ? kDarkPrimary : kLightPrimary,
              border: Border.all(
                color: darkModeOn ? kDarkStroke : kLightStroke,
                width: 2,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
              ),
            ),
            margin: UniversalPlatform.isMacOS
                ? const EdgeInsets.only(top: 30)
                : EdgeInsets.zero,
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    _desktopKey.currentState!.openDrawer();
                  },
                  icon: const Icon(YaruIcons.menu),
                ),
                kVSpace,
                ...List.generate(
                  menu.length,
                  (index) {
                    return ScrawlNavRailItem(
                      index: index,
                      tooltip: menu[index]['text'],
                      icon: menu[index]['icon'],
                      selectedIndex: _selectedIndex,
                      onTap: () => setState(() {
                        _selectedIndex = index;
                        _onDrawerItemSelect(menu[index]['id']);
                      }),
                    );
                  },
                ),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ScrawlNavRailItem(
                          index: 9,
                          tooltip: 'Settings',
                          selectedIndex: _selectedIndex,
                          icon: YaruIcons.settings,
                          onTap: () => showSettings(),
                        ),
                        ScrawlNavRailItem(
                          index: 10,
                          tooltip: globals.user!.userName,
                          selectedIndex: _selectedIndex,
                          icon: YaruIcons.user,
                          onTap: () => showProfile(),
                        ),
                      ]),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(children: [
              _getDrawerItemWidget(_selectedDrawerIndex),
              Visibility(
                visible: !UniversalPlatform.isMacOS && !UniversalPlatform.isWeb,
                child: Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.all(10),
                    child: const WindowControls(),
                  ),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }

  void showProfile() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 1000, maxHeight: 800),
                child: const DesktopProfileScreen()),
          );
        });
  }

  void showSettings() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 1000, maxHeight: 800),
                child: const DesktopSettingsScreen()),
          );
        });
  }

  void signOut() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }
}
