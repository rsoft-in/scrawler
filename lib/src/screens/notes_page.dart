import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/models/notes.dart';
import 'package:scrawler/src/screens/note_view_page.dart';
import 'package:scrawler/src/widgets/filter_button.dart';
import 'package:scrawler/src/widgets/scrawl_empty.dart';
import 'package:scrawler/src/widgets/scrawl_note_list_item.dart';
import 'package:scrawler/src/widgets/scrawl_snackbar.dart';

import '../helpers/globals.dart' as globals;

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  int filterIndex = 0;
  List<Map<String, dynamic>> filterMap = [
    {"name": "All", "index": 0},
    {"name": "Favorites", "index": 1},
  ];

  Future<NotesResult> getNotes() async {
    try {
      final response = await http.Client().post(
        Uri.parse("${globals.apiServer}/getnotes"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': globals.user.userId,
          'fav': filterIndex == 1 ? 1 : 0,
          'note_label': ''
        }),
      );
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        return NotesResult(
            parsed.map<Notes>((json) => Notes.fromJson(json)).toList(), 0, '');
      } else {
        return NotesResult([], 0, response.body);
      }
    } catch (e) {
      if (mounted) showSnackBar(context, '$e');
      return NotesResult([], 0, '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: filterMap
                    .map((item) => FilterButton(
                          label: item['name'],
                          index: item['index'],
                          selectedIndex: filterIndex,
                          onTap: () {
                            setState(() {
                              filterIndex = item['index'];
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<NotesResult>(
              future: getNotes(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                    if (snapshot.data!.error.isNotEmpty) {
                      return Center(
                        child: Text(snapshot.data!.error),
                      );
                    }
                    if (snapshot.data!.notes.isEmpty) {
                      return Center(
                        child: EmptyWidget(
                          text: "You don't have any Notes",
                          width: MediaQuery.of(context).size.width * 0.6,
                          onTap: () => openNoteView(Notes.empty()),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.notes.length,
                      itemBuilder: (context, index) {
                        List<Notes> notes = snapshot.data!.notes;
                        return NoteListItemWidget(
                          selectedIndex: 0,
                          isSelected: false,
                          note: notes[index],
                          onTap: () => openNoteView(notes[index]),
                          onLongPress: () => openNoteOption(notes[index]),
                        );
                      },
                    );
                  default:
                    return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteView(Notes.empty()),
        child: Icon(Symbols.add),
      ),
    );
  }

  void openNoteView(Notes note) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoteView(note: note),
        ));
    if (result) {
      setState(() {});
    }
  }

  void openNoteOption(Notes note) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: kPaddingLarge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: kPaddingLarge,
                child: Row(
                  children: [
                    Text(
                      note.noteTitle,
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    CloseButton(
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Symbols.favorite),
                title: Text('Set as Favorite'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Symbols.palette),
                title: Text('Set Color'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Symbols.delete,
                  color: Colors.red,
                ),
                title: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {},
              )
            ],
          ),
        );
      },
    );
  }
}
