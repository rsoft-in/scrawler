import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/globals.dart' as globals;
import 'package:bnotes/common/string_values.dart';
import 'package:bnotes/desktop/desktop_app.dart';
import 'package:bnotes/desktop/pages/desktop_notes_page.dart';
import 'package:bnotes/desktop/pages/desktop_tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({Key? key}) : super(key: key);

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  late SharedPreferences prefs;
  List<Map<String, dynamic>> menu = [];
  String _selectedDrawerIndex = 'all_notes';

  _onDrawerItemSelect(String menuId) {
    setState(() => _selectedDrawerIndex = menuId);
  }

  _getDrawerItemWidget(String menuId) {
    switch (menuId) {
      case 'all_notes':
        return DesktopNotesPage();
      case 'all_tasks':
        return DesktopTasksPage();
      default:
        return new Text("Error");
    }
  }

  @override
  void initState() {
    super.initState();
    // Menu Items
    menu = [
      {
        'id': 'all_notes',
        'icon': Icons.notes_outlined,
        'text': kLabels['notes']!,
        'color': 0xFF5EAAA8
      },
      {
        'id': 'all_tasks',
        'icon': Icons.check_box_outlined,
        'text': kLabels['tasks']!,
        'color': 0xFFFBABAB
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget drawer = Drawer(
      elevation: 0,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: Text(
              kAppName,
              style: TextStyle(fontSize: 26.0),
            ),
          ),
          // Menu Items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  ...List.generate(menu.length, (index) {
                    return ListTile(
                      selectedTileColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(menu[index]['color']).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Icon(
                          menu[index]['icon'],
                          size: 20.0,
                          color: Color(menu[index]['color']),
                        ),
                      ),
                      title: Text(menu[index]['text']),
                      selected: menu[index]['id'] == _selectedDrawerIndex,
                      onTap: () {
                        setState(() {});
                        _onDrawerItemSelect(menu[index]['id']);
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black87,
                      child: Icon(Icons.person_outline_outlined),
                    ),
                    title: Text(globals.user!.userName),
                    onTap: () {},
                  ),
                ),
                kHSpace,
                IconButton(
                  onPressed: () async {
                    prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => DesktopApp()),
                        (route) => false);
                  },
                  icon: Icon(Icons.exit_to_app_outlined),
                ),
              ],
            ),
          )
        ],
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        drawer,
        VerticalDivider(
          width: 0.5,
        ),
        Expanded(
          child: _getDrawerItemWidget(_selectedDrawerIndex),
        ),
      ],
    );
  }
}
