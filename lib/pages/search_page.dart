import 'package:bnotes/common/constants.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/pages/note_reader_page.dart';
import 'package:bnotes/widgets/note_card_list.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Notes> notesList = [];
  int selectedPageColor = 1;
  final dbHelper = DatabaseHelper.instance;
  TextEditingController _searchController = new TextEditingController();

  final FocusNode searchFocusNode = FocusNode();

  bool _showClearButton = false;

  loadNotes(searchText) async {
    if (searchText.toString().isEmpty)
      notesList.clear();
    else
      await dbHelper.getNotesAll(searchText).then((value) {
        setState(() {
          print(value.length);
          notesList = value;
        });
      });
  }

  @override
  void initState() {
    // loadNotes();
    _searchController.addListener(() {
      setState(() {
        _showClearButton = _searchController.text.length > 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 21, bottom: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: TextField(
                    controller: _searchController,
                    focusNode: searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: darkModeOn
                              ? Colors.grey.withOpacity(0.3)
                              : FlexColor.jungleLightPrimary.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: darkModeOn
                              ? Colors.grey.withOpacity(0.3)
                              : FlexColor.jungleLightPrimary.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: darkModeOn
                              ? Colors.grey.withOpacity(0.3)
                              : FlexColor.jungleLightPrimary.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) => loadNotes(value),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Visibility(
                    visible: _showClearButton,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                          });
                          notesList.clear();
                        },
                        child: Icon(Iconsax.close_circle)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _searchController.text.isEmpty,
            child: Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Icon(Iconsax.search_status, size: 120),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Type to start searching.....',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 22),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: _searchController.text.isNotEmpty,
            child: Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemBuilder: (context, index) {
                  return NoteCardList(
                    note: notesList[index],
                    onTap: () {
                      _showNoteReader(context, notesList[index]);
                    },
                  );
                },
                itemCount: notesList.length,
              ),
            )),
          )
        ],
      ),
    );
  }

  void _showNoteReader(BuildContext context, Notes _note) async {
    Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new NoteReaderPage(
              note: _note,
            )));
  }
}
