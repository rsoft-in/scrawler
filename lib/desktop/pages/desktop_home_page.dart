import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/globals.dart' as globals;
import 'package:bnotes/common/string_values.dart';
import 'package:bnotes/desktop/pages/desktop_notes_page.dart';
import 'package:bnotes/desktop/pages/desktop_tasks_page.dart';
import 'package:flutter/material.dart';

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({Key? key}) : super(key: key);

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  String _selectedMenu = "Notes";
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
        'text': 'Notes',
        'color': 0xFF5EAAA8
      },
      {
        'id': 'all_tasks',
        'icon': Icons.check_box_outlined,
        'text': 'Tasks',
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
                        _selectedMenu = menu[index]['text'];
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
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black87,
                  child: Icon(Icons.person_outline_outlined),
                ),
                kHSpace,
                Text(globals.user!.userName),
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
          child: Scaffold(
            appBar: ScrawlAppBar(title: _selectedMenu),
            body: _getDrawerItemWidget(_selectedDrawerIndex),
          ),
        ),
      ],
    );
  }
}

class ScrawlAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  const ScrawlAppBar({Key? key, required this.title})
      : preferredSize = const Size.fromHeight(140.0),
        super(key: key);

  @override
  State<ScrawlAppBar> createState() => _ScrawlAppBarState();
}

class _ScrawlAppBarState extends State<ScrawlAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Spacer(),
          SizedBox(
            width: 180.0,
            child: TextField(
              decoration: InputDecoration(
                hintText: kLabels['search'],
                prefixIcon: Icon(Icons.search_outlined),
              ),
            ),
          ),
          kHSpace,
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add_outlined),
            label: Text(kLabels['new_note']!),
          ),
        ],
      ),
    );
  }
}
