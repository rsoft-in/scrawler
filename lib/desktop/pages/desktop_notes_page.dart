import 'dart:convert';

import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/globals.dart' as globals;
import 'package:bnotes/common/string_values.dart';
import 'package:bnotes/common/adaptive.dart';
import 'package:bnotes/common/utility.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/providers/notes_api_provider.dart';
import 'package:bnotes/widgets/scrawl_empty.dart';
import 'package:bnotes/widgets/scrawl_note_date_widget.dart';
import 'package:bnotes/widgets/scrawl_note_list_item.dart';
import 'package:bnotes/widgets/scrawl_note_title_header.dart';
import 'package:bnotes/widgets/scrawl_app_bar.dart';
import 'package:bnotes/widgets/scrawl_notes_app_bar.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  int selectedIndex = 0;
  bool isSelected = false;

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

  void deleteNotes(String noteId) async {
    Map<String, String> post = {
      'postdata': jsonEncode({
        'api_key': globals.apiKey,
        'note_id': noteId,
      })
    };
    NotesApiProvider.deleteNotes(post).then((value) {
      if (value['status']) {
        getNotes();
        selectedIndex = 0;
        isSelected = false;
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
        : Row(
            children: [
              SizedBox(
                width: 350,
                child: Scaffold(
                  appBar: ScrawlAppBar(
                    title: kLabels['notes']!,
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: kLabels['search'],
                                  prefixIcon: Icon(
                                    BootstrapIcons.search,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                            kHSpace,
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showEdit = true;
                                  noteTitleController.text = "New Note";
                                  noteTextController.text = "";
                                });
                              },
                              child: Icon(BootstrapIcons.plus),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: isBusy
                            ? Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : (notes.length > 0
                                ? ListView.builder(
                                    padding: kGlobalOuterPadding,
                                    itemCount: notes.length,
                                    itemBuilder: (context, index) {
                                      return NoteListItemWidget(
                                          note: notes[index],
                                          selectedIndex: selectedIndex,
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                              isSelected = true;
                                            });
                                          },
                                          isSelected: index == selectedIndex &&
                                              isSelected);
                                    },
                                  )
                                : Center(
                                    child: Text('No Notes!'),
                                  )),
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                width: 0.5,
              ),
              Expanded(
                child: Scaffold(
                  body: Visibility(
                    visible: isSelected,
                    replacement: EmptyWidget(
                        text: 'Select a note to Preview.',
                        width: MediaQuery.of(context).size.width * 0.5 * 0.8,
                        asset: 'images/undraw_playful_cat.svg'),
                    child: Padding(
                      padding: kGlobalOuterPadding * 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NoteTitleWidget(
                              text: notes.isEmpty
                                  ? ''
                                  : notes[selectedIndex].noteTitle),
                          NoteDateWidget(
                            text: notes.isEmpty
                                ? ''
                                : Utility.formatDateTime(
                                    notes[selectedIndex].noteDate),
                          ),
                          SelectableText(
                            notes.isEmpty ? '' : notes[selectedIndex].noteText,
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  floatingActionButton: Visibility(
                    visible: isSelected,
                    replacement: Container(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: kBorderColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              TextButton(
                                  onPressed: () {},
                                  child: Icon(BootstrapIcons.pencil)),
                              TextButton(
                                  onPressed: () {},
                                  child: Icon(BootstrapIcons.palette2)),
                              TextButton(
                                  onPressed: () {},
                                  child: Icon(BootstrapIcons.tags)),
                              TextButton(
                                  onPressed: () =>
                                      deleteNotes(notes[selectedIndex].noteId),
                                  child: Icon(BootstrapIcons.trash3)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
