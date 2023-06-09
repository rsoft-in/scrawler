import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/string_values.dart';
import 'package:bnotes/desktop/pages/desktop_notes_screen.dart';
import 'package:bnotes/desktop/pages/desktop_profile_screen.dart';
import 'package:bnotes/desktop/pages/desktop_tasks_screen.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesktopApp extends StatefulWidget {
  const DesktopApp({Key? key}) : super(key: key);

  @override
  State<DesktopApp> createState() => _DesktopAppState();
}

class _DesktopAppState extends State<DesktopApp> {
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
    super.initState();

    // Menu Items
    menu = [
      {
        'id': 'all_notes',
        'index': 0,
        'icon': BootstrapIcons.justify_left,
        'icon_filled': BootstrapIcons.justify_left,
        'text': kLabels['notes']!,
        'color': 0xFF5EAAA8
      },
      {
        'id': 'all_tasks',
        'index': 1,
        'icon': BootstrapIcons.check_square,
        'icon_filled': BootstrapIcons.check_square,
        'text': kLabels['tasks']!,
        'color': 0xFFFBABAB
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);

    Widget drawer = SizedBox(
      width: 250,
      child: Drawer(
        // elevation: 0,
        // backgroundColor: Colors.white,
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
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 15.0),
                          selectedTileColor: kPrimaryColor.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          leading: Container(
                            width: 35,
                            height: 35,
                            alignment: Alignment.center,
                            // decoration: BoxDecoration(
                            //   color:
                            //       Color(menu[index]['color']).withOpacity(0.2),
                            //   borderRadius: BorderRadius.circular(8.0),
                            // ),
                            child: Icon(
                              menu[index]['icon'],
                              size: 16.0,
                              color: Color(menu[index]['color']),
                            ),
                          ),
                          title: Text(menu[index]['text']),
                          selected: menu[index]['id'] == _selectedDrawerIndex,
                          onTap: () {
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                leading: const CircleAvatar(
                  // backgroundColor: Colors.black87,
                  child: Icon(BootstrapIcons.person),
                ),
                title: Text(globals.user!.userName),
                onTap: () => showProfile(),
              ),
            )
          ],
        ),
      ),
    );

    Widget navigationRail = NavigationRail(
      labelType: labelType,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
          _onDrawerItemSelect(menu[index]['id']);
        });
      },
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.asset('images/bnotes-transparent.png'),
      ),
      destinations: <NavigationRailDestination>[
        ...List.generate(menu.length, (index) {
          return NavigationRailDestination(
            icon: Icon(
              menu[index]['icon'],
              size: 18.0,
              color: Color(menu[index]['color']),
            ),
            selectedIcon: Icon(
              menu[index]['icon'],
              size: 20.0,
              color: Color(menu[index]['color']),
            ),
            label: Text(menu[index]['text']),
          );
        }),
      ],
      trailing: IconButton(
        onPressed: () => showProfile(),
        icon: const Icon(
          BootstrapIcons.person,
          color: kPrimaryColor,
        ),
      ),
    );

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isDesktop) drawer else navigationRail,
          // const VerticalDivider(
          //   width: 0.5,
          // ),
          Expanded(
            child: _getDrawerItemWidget(_selectedDrawerIndex),
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

  void signOut() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }
}
