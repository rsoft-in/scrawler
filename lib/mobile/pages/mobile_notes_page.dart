import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/dbhelper.dart';
// import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:bnotes/helpers/language.dart';
import 'package:bnotes/mobile/pages/mobile_note_editor.dart';
import 'package:bnotes/mobile/pages/mobile_note_reader.dart';
import 'package:bnotes/models/notes.dart';
import 'package:bnotes/widgets/scrawl_empty.dart';
import 'package:bnotes/widgets/scrawl_note_list_item.dart';
import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';

import '../../models/menu_item.dart';

class MobileNotesPage extends StatefulWidget {
  const MobileNotesPage({Key? key}) : super(key: key);

  @override
  State<MobileNotesPage> createState() => _MobileNotesPageState();
}

class _MobileNotesPageState extends State<MobileNotesPage> {
  final dbHelper = DBHelper.instance;
  List<Notes> notes = [];
  List<MenuItem> contextMenuItems = [
    MenuItem('edit', Language.get('edit'), '', YaruIcons.pen),
    MenuItem('delete', Language.get('delete'), '', YaruIcons.trash),
    MenuItem('color', Language.get('color'), '', YaruIcons.colors),
    MenuItem('tags', Language.get('tag'), '', YaruIcons.tag)
  ];

  @override
  void initState() {
    loadNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var brightness = MediaQuery.of(context).platformBrightness;
    // bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
    //     (brightness == Brightness.dark &&
    //         globals.themeMode == ThemeMode.system));
    return Scaffold(
      body: notes.isEmpty
          ? EmptyWidget(
              text: Language.get('select_note'),
              width: MediaQuery.of(context).size.width * 0.8,
              asset: 'images/undraw_playful_cat.svg')
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return NoteListItemWidget(
                  isSelected: false,
                  note: notes[index],
                  selectedIndex: 0,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MobileNoteReader(note: notes[index]))),
                  onLongPress: () => showOptions(context, notes[index]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => editNote(Notes.empty()),
        child: const Icon(YaruIcons.plus),
      ),
    );
  }

  Future<void> loadNotes() async {
    dbHelper.getNotesAll('', 'note_date desc').then((value) {
      setState(() {
        notes = value;
      });
    });
  }

  void editNote(Notes note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MobileNoteEditor(note: note)),
    );
    if (result) {
      loadNotes();
    }
  }

  void showOptions(BuildContext context, Notes note) {
    showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (context) {
          return Container(
            padding: kGlobalOuterPadding,
            child: ListView.builder(
                itemCount: contextMenuItems.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () =>
                        onContextSelected(contextMenuItems[index].value, note),
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    child: Padding(
                      padding: kGlobalOuterPadding,
                      child: Row(
                        children: [
                          Icon(
                            contextMenuItems[index].icon,
                            size: 18,
                          ),
                          kHSpace,
                          Expanded(
                            child: Text(contextMenuItems[index].caption),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        });
  }

  void onContextSelected(String action, Notes note) {
    Navigator.pop(context);
    print(action);
  }
}
