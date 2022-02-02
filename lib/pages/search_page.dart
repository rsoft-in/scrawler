import 'package:bnotes/constants.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/pages/note_reader_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';

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
    bool darkModeOn = brightness == Brightness.dark;
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size(0, 5), child: Container()),
      body: Padding(
        padding: kGlobalOuterPadding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  // Icon(
                  //   Icons.search_rounded,
                  // ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextField(
                    controller: _searchController,
                    focusNode: searchFocusNode,
                    decoration: InputDecoration(hintText: 'Search'),
                    onChanged: (value) => loadNotes(value),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Visibility(
                    visible: _showClearButton,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                          });
                          notesList.clear();
                        },
                        child: Icon(Iconsax.close_circle)),
                  ),
                ],
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
                        height: 80,
                      ),
                      Icon(Iconsax.search_status, size: 100),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Type to start searching.....',
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _searchController.text.isNotEmpty,
              child: Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    color: darkModeOn
                        ? FlexColor.blueWhaleDarkPrimary.lighten()
                        : FlexColor.blueWhaleDarkPrimary.lighten(30),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedPageColor = notesList[index].noteColor;
                        });
                        _showNoteReader(context, notesList[index]);
                      },
                      child: Padding(
                        padding: kGlobalCardPadding,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: notesList[index].noteTitle.isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  notesList[index].noteTitle,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: darkModeOn
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                notesList[index].noteText,
                                style: TextStyle(
                                  color: darkModeOn
                                      ? Colors.white60
                                      : Colors.black38,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notesList[index].noteLabel,
                                        style: TextStyle(
                                            color: darkModeOn
                                                ? Colors.white38
                                                : Colors.black38,
                                            fontSize: 12.0),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        Utility.formatDateTime(
                                            notesList[index].noteDate),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: darkModeOn
                                                ? Colors.white38
                                                : Colors.black38,
                                            fontSize: 12.0),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: notesList.length,
              )),
            )
          ],
        ),
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
