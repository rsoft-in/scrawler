import 'dart:convert';

import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/globals.dart' as globals;
import 'package:bnotes/common/string_values.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/utility.dart';
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
  FocusNode focusNode = FocusNode();
  int wordCount = 0;
  bool isDesktop = false;

  TextEditingController noteTitleController = TextEditingController();
  TextEditingController noteTextController = TextEditingController();
  String noteId = "";

  void getNotes() async {
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

  void saveNotes() async {
    Map<String, String> post = {
      'postdata': jsonEncode({
        'api_key': globals.apiKey,
        'note_id': noteId,
        'note_user_id': globals.user!.userId,
        'note_date': Utility.getDateString(),
        'note_title': noteTitleController.text,
        'note_text': noteTextController.text,
        'note_label': '',
        'note_archived': 0,
        'note_color': 0,
        'note_image': '',
        'note_audio_file': ''
      })
    };
    print(post);
    NotesApiProvider.updateNotes(post).then((value) {
      if (value['status']) {
        getNotes();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value['error']),
            duration: Duration(seconds: 2),
          ),
        );
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
    isDesktop = isDisplayDesktop(context);
    return showEdit
        ? Scaffold(
            appBar: ScrawlNotesAppBar(
              title: noteTitleController.text,
              titleController: noteTitleController,
              onActionPressed: () {
                setState(() {
                  showEdit = false;
                });
                if (noteTextController.text.isNotEmpty) saveNotes();
              },
              onColorPressed: () {},
              onTagPressed: () {},
            ),
            body: Container(
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                controller: noteTextController,
                focusNode: focusNode,
                expands: true,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Type something here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide: BorderSide.none,
                  ),
                  filled: false,
                ),
                onChanged: (value) {
                  var wordList = value.trim().split(' ');
                  if (value.trim().isEmpty) {
                    wordCount = 0;
                  } else {
                    wordCount = wordList.length;
                  }
                  setState(() {});
                },
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$wordCount words',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: ScrawlAppBar(
              title: kLabels['notes']!,
              actionButtonTitle: kLabels['new_note']!,
              onActionPressed: () {
                setState(() {
                  showEdit = true;
                  noteTitleController.text = "New Note";
                  noteTextController.text = "";
                  focusNode.requestFocus();
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
                            // subtitle: Text(notes[index].noteText),
                            // isThreeLine: true,
                          );
                        },
                      )
                    : Center(child: Text('No Data'))),
          );
  }
}
