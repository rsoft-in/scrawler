import 'dart:convert';

import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/globals.dart' as globals;
import 'package:bnotes/common/string_values.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/providers/notes_api_provider.dart';
import 'package:bnotes/widgets/scrawl_note_date_widget.dart';
import 'package:bnotes/widgets/scrawl_note_title_header.dart';
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
                          horizontal: 15,
                          vertical: 15,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: kLabels['search'],
                                  prefixIcon: Icon(Icons.search_outlined),
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
                              child: Icon(Icons.add_outlined),
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
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5.0,
                                          horizontal: 10.0,
                                        ),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                              isSelected = true;
                                            });
                                          },
                                          child: Container(
                                            padding: kGlobalCardPadding * 2,
                                            decoration: BoxDecoration(
                                              color: index == selectedIndex &&
                                                      isSelected
                                                  ? kPrimaryColor
                                                      .withOpacity(0.08)
                                                  : Color(0xFFF9F9F9)
                                                      .withOpacity(0.6),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8.0,
                                                    vertical: 4.0,
                                                  ),
                                                  child: Text(
                                                    notes[index].noteTitle,
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8.0,
                                                    vertical: 4.0,
                                                  ),
                                                  child: Text(
                                                    notes[index].noteText,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(notes[index]
                                                          .noteLabel),
                                                    ),
                                                    Text(
                                                      Utility.formatDateTime(
                                                          notes[index]
                                                              .noteDate),
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text('No Data'),
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
                    replacement: Container(), // Replace with an illustration
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
                                  child: Icon(Icons.edit_outlined)),
                              TextButton(
                                  onPressed: () {},
                                  child: Icon(Icons.palette_outlined)),
                              TextButton(
                                  onPressed: () {},
                                  child: Icon(Icons.label_outline)),
                              TextButton(
                                  onPressed: () {},
                                  child: Icon(Icons.delete_outlined)),
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
