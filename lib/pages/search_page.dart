import 'package:bnotes/constants.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/pages/note_reader_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Container(
      child: Padding(
        padding: kGlobalOuterPadding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: searchFocusNode,
                      onChanged: (value) => loadNotes(value),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.search_rounded,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Visibility(
                    visible: _showClearButton,
                    // child: InkWell(
                    //   onTap: () {
                    //     setState(() {
                    //       _searchController.clear();
                    //     });
                    //     notesList.clear();
                    //   },
                    //   child: Icon(Icons.clear),
                    // ),
                    child: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                        notesList.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_searchController.text.isNotEmpty)
              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: darkModeOn ? kSecondaryDark : Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 1.0,
                              offset: new Offset(1, 1)),
                        ]),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedPageColor = notesList[index].noteColor;
                        });
                        _showNoteReader(context, notesList[index]);
                      },
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
                                  color:
                                      darkModeOn ? Colors.white : Colors.black,
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
                  );
                },
                itemCount: notesList.length,
              )),
            if (_searchController.text.isEmpty)
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search,
                        size: 120,
                      ),
                      Text(
                        'Type to start searching',
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 22),
                      ),
                    ],
                  ),
                ),
              ),
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
