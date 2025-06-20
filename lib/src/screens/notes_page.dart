import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/models/notes.dart';
import 'package:scrawler/src/providers/notes_api_provider.dart';
import 'package:scrawler/src/screens/note_view_page.dart';
import 'package:scrawler/src/widgets/filter_button.dart';
import 'package:scrawler/src/widgets/scrawl_empty.dart';
import 'package:scrawler/src/widgets/scrawl_note_list_item.dart';

import '../helpers/globals.dart' as globals;
import '../widgets/scrawl_color_picker.dart';
import '../widgets/scrawl_snackbar.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  int filterIndex = 0;
  List<Map<String, dynamic>> filterMap = [
    {"name": "notes_all".tr(), "index": 0},
    {"name": "notes_fav".tr(), "index": 1},
  ];

  Future<NotesResult> getNotes() async {
    final response = await NotesApiProvider.getNotes(json.encode({
      'user_id': globals.user.userId,
      'fav': filterIndex == 1 ? 1 : 0,
      'note_label': ''
    }));
    return response;
  }

  Future<void> updateFavorite(Notes note) async {
    final response = await NotesApiProvider.updateFavorite(json.encode(
      {'id': note.noteId},
    ));
    if (response['status']) {
      setState(() {});
      if (mounted) Navigator.pop(context);
      if (mounted) showSnackBar(context, 'done'.tr());
    } else {
      if (mounted) showSnackBar(context, response['error']);
    }
  }

  Future<void> updateColor(Notes note, int colorCode) async {
    final response = await NotesApiProvider.updateColor(json.encode(
      {'id': note.noteId, 'color': colorCode},
    ));
    if (response['status']) {
      setState(() {});
      if (mounted) Navigator.pop(context);
      if (mounted) showSnackBar(context, 'done'.tr());
    } else {
      if (mounted) showSnackBar(context, response['error']);
    }
  }

  Future<void> deleteNote(String noteId) async {
    final response = await NotesApiProvider.delete(json.encode(
      {'id': noteId},
    ));
    if (response['status']) {
      setState(() {});
      if (mounted) Navigator.pop(context);
      if (mounted) showSnackBar(context, 'deleted'.tr());
    } else {
      if (mounted) showSnackBar(context, response['error']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'welcome_message'.tr(namedArgs: {'name': globals.user.userName})),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...filterMap.map((item) => FilterButton(
                        selectedIndex: filterIndex,
                        index: item['index'],
                        label: item['name'],
                        onTap: () {
                          setState(() {
                            filterIndex = item['index'];
                          });
                        },
                      )),
                  VerticalDivider(),
                  IconButton(
                    onPressed: () {},
                    tooltip: 'new_label'.tr(),
                    icon: Icon(Symbols.add_circle),
                  ),
                  IconButton(
                    onPressed: () {},
                    tooltip: 'manage_labels'.tr(),
                    icon: Icon(Symbols.folder_managed),
                  ),
                ],
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            EmptyWidget(
                              text: "no_notes".tr(),
                              width: MediaQuery.of(context).size.width * 0.6,
                            ),
                            if (filterIndex == 0)
                              FilledButton.tonal(
                                onPressed: () => openNoteView(Notes.empty()),
                                child: Text('add'.tr()),
                              )
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.notes.length,
                      itemBuilder: (context, index) {
                        List<Notes> notes = snapshot.data!.notes;
                        return NoteListItem(
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
                title: Text(note.noteFavorite
                    ? 'remove_from_fav'.tr()
                    : 'set_as_fav'.tr()),
                onTap: () => updateFavorite(note),
              ),
              ListTile(
                leading: Icon(Symbols.palette),
                title: Text('set_color'.tr()),
                onTap: () => openColorPicker(note),
              ),
              ListTile(
                leading: Icon(
                  Symbols.delete,
                  color: Colors.red,
                ),
                title: Text(
                  'delete'.tr(),
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  confirmDelete(note);
                },
              )
            ],
          ),
        );
      },
    );
  }

  void confirmDelete(Notes note) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('confirm'.tr()),
        content: Text('confirm_delete'.tr()),
        actions: [
          TextButton(
            onPressed: () {
              deleteNote(note.noteId);
            },
            child: Text(
              'yes'.tr(),
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('no'.tr()),
          ),
        ],
      ),
    );
  }

  void openColorPicker(Notes note) async {
    final colorCode = await showDialog(
      context: context,
      builder: (context) {
        return ScrawlColorPicker();
      },
    );
    if (colorCode != null) {
      updateColor(note, colorCode);
    }
  }
}
