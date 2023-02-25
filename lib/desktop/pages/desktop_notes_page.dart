import 'dart:convert';

import 'package:bnotes/common/adaptive.dart';
import 'package:bnotes/common/constants.dart';
import 'package:bnotes/common/globals.dart' as globals;
import 'package:bnotes/common/language.dart';
import 'package:bnotes/common/string_values.dart';
import 'package:bnotes/common/utility.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/providers/notes_api_provider.dart';
import 'package:bnotes/widgets/scrawl_alert_dialog.dart';
import 'package:bnotes/widgets/scrawl_app_bar.dart';
import 'package:bnotes/widgets/scrawl_empty.dart';
import 'package:bnotes/widgets/scrawl_note_date_widget.dart';
import 'package:bnotes/widgets/scrawl_note_list_item.dart';
import 'package:bnotes/widgets/scrawl_note_title_header.dart';
import 'package:bnotes/widgets/scrawl_snackbar.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
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
  FocusNode focusNode = FocusNode();
  int wordCount = 0;
  bool isDesktop = false;
  int selectedIndex = 0;
  bool isSelected = false;
  bool darkModeOn = false;

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
          duration: const Duration(seconds: 2),
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
        ScaffoldMessenger.of(context)
            .showSnackBar(ScrawlSnackBar.show('Successfully Updated'));
        getNotes();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value['error']),
            duration: const Duration(seconds: 2),
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
            duration: const Duration(seconds: 2),
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
    var brightness = MediaQuery.of(context).platformBrightness;
    darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (globals.themeMode == ThemeMode.system &&
            brightness == Brightness.dark));
    return Row(
      children: [
        SizedBox(
          width: 350,
          child: Scaffold(
            appBar: ScrawlAppBar(
              title: Language.get('notes'),
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
                            prefixIcon: const Icon(
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
                            noteId = "";
                            noteTitleController.text = "";
                            noteTextController.text = "";
                          });
                          showEditDialog(context);
                        },
                        child: const Icon(BootstrapIcons.plus),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isBusy
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : (notes.isNotEmpty
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
                                    isSelected:
                                        index == selectedIndex && isSelected);
                              },
                            )
                          : Center(
                              child: Text(Language.get('no_notes')),
                            )),
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(
          width: 0.5,
        ),
        Expanded(
          child: Scaffold(
            body: Visibility(
              visible: isSelected,
              replacement: EmptyWidget(
                  text: Language.get('select_note'),
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
                      style: const TextStyle(
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
                            onPressed: () {
                              setState(() {
                                noteId = notes[selectedIndex].noteId;
                                noteTitleController.text =
                                    notes[selectedIndex].noteTitle;
                                noteTextController.text =
                                    notes[selectedIndex].noteText;
                              });
                              showEditDialog(context);
                            },
                            child: const Icon(
                              BootstrapIcons.pencil,
                              size: 18,
                            )),
                        TextButton(
                            onPressed: () {},
                            child: const Icon(
                              BootstrapIcons.palette2,
                              size: 18,
                            )),
                        TextButton(
                            onPressed: () {},
                            child: const Icon(
                              BootstrapIcons.tags,
                              size: 18,
                            )),
                        TextButton(
                            onPressed: () => confirmDelete(
                                context, notes[selectedIndex].noteId),
                            child: const Icon(
                              BootstrapIcons.trash3,
                              size: 18,
                            )),
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

  void showEditDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.all(74.0),
              child: Container(
                padding: kGlobalOuterPadding,
                decoration: BoxDecoration(
                  color: darkModeOn ? const Color(0xFF333333) : Colors.white,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: noteTitleController,
                        style: const TextStyle(fontSize: 20.0),
                        decoration: InputDecoration.collapsed(
                          hintText: Language.get('enter_title'),
                        ),
                      ),
                      kVSpace,
                      Text(
                        '1 ${Language.get('min_ago')}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      kVSpace,
                      Row(
                        children: [
                          const Icon(
                            BootstrapIcons.tag,
                            size: 16,
                          ),
                          const VerticalDivider(color: Colors.black),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(BootstrapIcons.plus),
                          ),
                        ],
                      ),
                      kVSpace,
                      Expanded(
                        child: TextField(
                          controller: noteTextController,
                          decoration: InputDecoration.collapsed(
                            hintText: Language.get('type_something'),
                          ),
                          expands: true,
                          maxLines: null,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            BootstrapIcons.palette,
                            size: 16,
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              if (noteTextController.text.isNotEmpty) {
                                saveNotes();
                              }
                              Navigator.pop(context);
                            },
                            child: Text(Language.get('save')),
                          ),
                          kHSpace,
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(Language.get('cancel')),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void confirmDelete(BuildContext context, String noteId) {
    showDialog(
        context: context,
        builder: (context) {
          return ScrawlConfirmDialog(
            onAcceptPressed: () {
              deleteNotes(noteId);
              Navigator.pop(context);
            },
            content: Language.get('confirm_delete'),
          );
        });
  }
}
