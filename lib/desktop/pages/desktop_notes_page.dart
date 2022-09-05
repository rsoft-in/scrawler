import 'dart:convert';

import 'package:bnotes/common/globals.dart' as globals;
import 'package:bnotes/common/string_values.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/providers/notes_api_provider.dart';
import 'package:bnotes/widgets/scrawl_app_bar.dart';
import 'package:bnotes/widgets/scrawl_notes_app_bar.dart';
import 'package:flutter/material.dart';

class DesktopNotesPage extends StatefulWidget {
  const DesktopNotesPage({Key? key}) : super(key: key);

  @override
  State<DesktopNotesPage> createState() => _DesktopNotesPageState();
}

class _DesktopNotesPageState extends State<DesktopNotesPage> {
  List<Notes> notes = [];
  int _pageNr = 0;
  bool isBusy = false;
  bool showEdit = false;

  void getNotes() async {
    Map<String, String> post = {
      'postdata': jsonEncode({
        'api_key': globals.apiKey,
        'uid': globals.user!.userId,
        'qry': 'test',
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
        notes = value.notes;
        isBusy = false;
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value.error),
          duration: Duration(seconds: 2),
        ));
      }
    });
  }

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return showEdit
        ? Scaffold(
            appBar: ScrawlNotesAppBar(
                child: Text(
                  kLabels['new_note']!,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                onActionPressed: () {},
                onColorPressed: () {},
                onTagPressed: () {},
                onClosePressed: () {
                  setState(() {
                    showEdit = false;
                  });
                }),
            body: Container(),
          )
        : Scaffold(
            appBar: ScrawlAppBar(
              title: kLabels['notes']!,
              actionButtonTitle: kLabels['new_note']!,
              onActionPressed: () {
                setState(() {
                  showEdit = true;
                });
              },
            ),
            body: isBusy
                ? Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : (notes.length > 0
                    ? ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(notes[index].noteTitle),
                          );
                        },
                      )
                    : Center(child: Text('No Data'))),
          );
  }
}
