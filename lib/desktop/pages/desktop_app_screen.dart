import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bnotes/desktop/pages/desktop_notes_screen.dart';
import 'package:bnotes/desktop/pages/desktop_profile_screen.dart';
import 'package:bnotes/desktop/pages/desktop_settings_screen.dart';
import 'package:bnotes/desktop/pages/desktop_tasks_screen.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:bnotes/models/label.dart';
import 'package:bnotes/widgets/rs_drawer_item.dart';
import 'package:bnotes/widgets/rs_icon.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/note_color.dart';
import '../../models/notes.dart';
import '../../providers/labels_api_provider.dart';
import '../../providers/notes_api_provider.dart';

class DesktopApp extends StatefulWidget {
  const DesktopApp({Key? key}) : super(key: key);

  @override
  State<DesktopApp> createState() => _DesktopAppState();
}

class _DesktopAppState extends State<DesktopApp> {
  final GlobalKey<ScaffoldState> _desktopKey = GlobalKey();

  late SharedPreferences prefs;
  bool isDesktop = false;
  final int _pageNr = 0;
  bool isBusy = false;
  List<Notes> notesList = [];
  List<Label> labelsList = [];

  List<Map<String, dynamic>> menu = [];
  String _selectedDrawerIndex = 'all_notes';
  final int _selectedIndex = 0;
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

  Future<void> getLabels() async {
    Map<String, String> post = {
      'postdata': jsonEncode({
        'api_key': globals.apiKey,
        'uid': globals.user!.userId,
        'qry': '',
        'sort': 'label_name',
        'page_no': 0,
        'offset': 100
      })
    };
    LabelsApiProvider.fecthLabels(post).then((value) {
      setState(() {
        if (value.error.isEmpty) {
          labelsList = value.labels;
        }
      });
    });
  }

  Future<void> getNotes() async {
    Map<String, String> post = {
      'postdata': jsonEncode({
        'api_key': globals.apiKey,
        'uid': globals.user!.userId,
        'qry': '',
        'sort': 'note_title',
        'page_no': _pageNr,
        'offset': 30
      })
    };
    setState(() {
      isBusy = true;
    });
    NotesApiProvider.fecthNotes(post).then((value) {
      if (value.error.isEmpty) {
        notesList = value.notes;
        isBusy = false;
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value.error),
          duration: const Duration(seconds: 2),
        ));
      }
    });
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
    getLabels();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));

    Widget drawer = Container(
      width: 280,
      // padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: kLightPrimary,
        border: Border(
          right: BorderSide(color: kLightStroke),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            RSDrawerItem(
              label: 'Search',
              icon: const RSIcon(icon: Symbols.search),
              onTap: () {},
            ),
            RSDrawerItem(
              icon: const RSIcon(icon: Symbols.add_circle),
              label: 'Add Note',
              onTap: () {},
            ),
            kHSpace,
            Expanded(
              child: isBusy
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(labelsList.length, (index) {
                            final notes = notesList
                                .where((el) => el.noteLabel
                                    .contains(labelsList[index].labelName))
                                .toList();
                            return ExpansionTile(
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide.none),
                              leading: const Icon(Symbols.folder),
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: Text(
                                labelsList[index].labelName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              children: notes
                                  .map((note) => RSDrawerItem(
                                        indent: true,
                                        icon: const RSIcon(
                                            icon: Symbols.description),
                                        label: note.noteTitle,
                                        trailing: Container(
                                          width: 5,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: NoteColor.getColor(
                                                note.noteColor, false),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onTap: () {},
                                      ))
                                  .toList(),
                            );
                          }),
                          ...notesList
                              .where((el) => el.noteLabel.isEmpty)
                              .toList()
                              .map((note) => RSDrawerItem(
                                    onTap: () {},
                                    icon:
                                        const RSIcon(icon: Symbols.description),
                                    label: note.noteTitle,
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
            ),
            RSDrawerItem(
              icon: const RSIcon(icon: Symbols.delete),
              label: 'Trash',
              onTap: () {},
            ),
            RSDrawerItem(
              icon: const RSIcon(icon: Symbols.settings),
              label: 'Settings',
              onTap: () {},
            ),
            RSDrawerItem(
              icon: const RSIcon(icon: Symbols.account_circle),
              label: 'Account',
              onTap: () {},
            ),
          ],
        ),
      ),
    );

    return isDesktop
        ? Scaffold(
            body: Row(
              children: [
                drawer,
                Expanded(
                  child: Center(
                    child: InkWell(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Welcome'),
                        )),
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            drawer: drawer,
            appBar: AppBar(),
            body: const Center(
              child: Text('Welcome'),
            ),
          );

    // Widget drawer = SizedBox(
    //   width: 250,
    //   child: Drawer(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Container(
    //           padding:
    //               const EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
    //           child: const Text(
    //             kAppName,
    //             style: TextStyle(fontSize: 26.0),
    //           ),
    //         ),
    //         // Menu Items
    //         Expanded(
    //           child: Padding(
    //             padding:
    //                 const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    //             child: ListView(
    //               children: [
    //                 ...List.generate(menu.length, (index) {
    //                   return Container(
    //                     margin: const EdgeInsets.only(bottom: 5.0),
    //                     child: ListTile(
    //                       selectedTileColor:
    //                           darkModeOn ? kDarkSelected : kLightSelected,
    //                       selectedColor: Colors.black,
    //                       leading: Container(
    //                         width: 35,
    //                         height: 35,
    //                         alignment: Alignment.center,
    //                         child: Icon(
    //                           menu[index]['icon'],
    //                         ),
    //                       ),
    //                       title: Text(kLabels[menu[index]['text']]!),
    //                       selected: menu[index]['id'] == _selectedDrawerIndex,
    //                       onTap: () {
    //                         _selectedIndex = index;
    //                         setState(() {});
    //                         _onDrawerItemSelect(menu[index]['id']);
    //                       },
    //                     ),
    //                   );
    //                 }),
    //               ],
    //             ),
    //           ),
    //         ),
    //         Padding(
    //           padding:
    //               const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
    //           child: ListTile(
    //             contentPadding:
    //                 const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
    //             leading: const CircleAvatar(
    //               child: Icon(YaruIcons.user),
    //             ),
    //             title: Text(globals.user!.userName),
    //             onTap: () => showProfile(),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );

    // return Scaffold(
    //   key: _desktopKey,
    //   drawer: drawer,
    //   backgroundColor: darkModeOn ? kDarkSecondary : kLightSecondary,
    //   body: Row(
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: [
    //       Container(
    //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    //         decoration: BoxDecoration(
    //           color: darkModeOn ? kDarkPrimary : kLightPrimary,
    //           border: Border.all(
    //             color: darkModeOn ? kDarkStroke : kLightStroke,
    //             width: 2,
    //           ),
    //           borderRadius: const BorderRadius.only(
    //             topRight: Radius.circular(10),
    //           ),
    //         ),
    //         margin: UniversalPlatform.isMacOS
    //             ? const EdgeInsets.only(top: 30)
    //             : EdgeInsets.zero,
    //         child: Column(
    //           children: [
    //             IconButton(
    //               onPressed: () {
    //                 _desktopKey.currentState!.openDrawer();
    //               },
    //               icon: const Icon(YaruIcons.menu),
    //             ),
    //             kVSpace,
    //             ...List.generate(
    //               menu.length,
    //               (index) {
    //                 return ScrawlNavRailItem(
    //                   index: index,
    //                   tooltip: menu[index]['text'],
    //                   icon: menu[index]['icon'],
    //                   selectedIndex: _selectedIndex,
    //                   onTap: () => setState(() {
    //                     _selectedIndex = index;
    //                     _onDrawerItemSelect(menu[index]['id']);
    //                   }),
    //                 );
    //               },
    //             ),
    //             Expanded(
    //               child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.end,
    //                   children: [
    //                     ScrawlNavRailItem(
    //                       index: 9,
    //                       tooltip: 'Settings',
    //                       selectedIndex: _selectedIndex,
    //                       icon: YaruIcons.settings,
    //                       onTap: () => showSettings(),
    //                     ),
    //                     ScrawlNavRailItem(
    //                       index: 10,
    //                       tooltip: globals.user!.userName,
    //                       selectedIndex: _selectedIndex,
    //                       icon: YaruIcons.user,
    //                       onTap: () => showProfile(),
    //                     ),
    //                   ]),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Expanded(
    //         child: Stack(children: [
    //           _getDrawerItemWidget(_selectedDrawerIndex),
    //           Visibility(
    //             visible: !UniversalPlatform.isMacOS && !UniversalPlatform.isWeb,
    //             child: Positioned(
    //               right: 0,
    //               child: Container(
    //                 padding: const EdgeInsets.all(4),
    //                 margin: const EdgeInsets.all(10),
    //                 child: const WindowControls(),
    //               ),
    //             ),
    //           )
    //         ]),
    //       ),
    //     ],
    //   ),
    // );
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
