import 'package:bnotes/constants.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/pages/note_reader_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return Scaffold(
      body: Padding(
        padding: kGlobalOuterPadding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color:
                      darkModeOn ? kSecondaryDark : Colors.grey.withOpacity(0.1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Search',
                        ),
                        autofocus: false,
                        onChanged: (value) => loadNotes(value),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            notesList[index].noteTitle,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: darkModeOn ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            notesList[index].noteText,
                            style: TextStyle(
                              color: darkModeOn ? Colors.white60 : Colors.black38,
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
            ))
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
