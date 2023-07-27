import 'package:bnotes/helpers/dbhelper.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:bnotes/helpers/language.dart';
import 'package:bnotes/mobile/pages/mobile_note_editor.dart';
import 'package:bnotes/models/notes.dart';
import 'package:bnotes/widgets/scrawl_empty.dart';
import 'package:bnotes/widgets/scrawl_note_list_item.dart';
import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';

class MobileNotesPage extends StatefulWidget {
  const MobileNotesPage({Key? key}) : super(key: key);

  @override
  State<MobileNotesPage> createState() => _MobileNotesPageState();
}

class _MobileNotesPageState extends State<MobileNotesPage> {
  final dbHelper = DBHelper.instance;
  List<Notes> notes = [];

  Future<void> loadNotes() async {
    dbHelper.getNotesAll('', 'note_date desc').then((value) {
      setState(() {
        notes = value;
      });
    });
  }

  @override
  void initState() {
    loadNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
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
                  onTap: () {},
                );
              },
            ),
      // floatingActionButton: ScrawlFloatingActionButton(
      //   icon: YaruIcons.plus,
      // onPressed: () => Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => MobileNoteEditor(
      //       note: Notes.empty(),
      //     ),
      //   ),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MobileNoteEditor(
              note: Notes.empty(),
            ),
          ),
        ),
        child: const Icon(YaruIcons.plus),
      ),
    );
  }
}
