import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:scrawler/src/helpers/adaptive.dart';
import 'package:scrawler/src/helpers/constants.dart';
import 'package:scrawler/src/models/label.dart';
import 'package:scrawler/src/models/notes.dart';
import 'package:scrawler/src/providers/labels_api_provider.dart';
import 'package:scrawler/src/providers/notes_api_provider.dart';
import 'package:scrawler/src/screens/note_view_page.dart';
import 'package:scrawler/src/widgets/rs_avatar.dart';
import 'package:scrawler/src/widgets/scrawl_empty.dart';

import '../helpers/globals.dart' as globals;
import '../helpers/note_color.dart';
import '../helpers/utility.dart';
import '../widgets/rs_toast.dart';
import '../widgets/scrawl_color_picker.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  int filterIndex = 0;

  List<Label> labels = [];
  List<Map<String, dynamic>> filterMap = [];
  List<Map<String, dynamic>> defaultLabels = [
    {"name": "notes_all".tr(), "index": 0},
    {"name": "notes_fav".tr(), "index": 1},
  ];

  Future<NotesResult> getNotes() async {
    final response = await NotesApiProvider.getNotes(json.encode({
      'user_id': globals.user.userId,
      'fav': filterIndex == 1 ? 1 : 0,
      'note_label': filterIndex == 0 ? '' : filterMap[filterIndex]['name']
    }));
    return response;
  }

  Future<void> getLabels() async {
    final response = await LabelsApiProvider.fecthLabels(json.encode({
      "user_id": globals.user.userId,
    }));
    if (response.error.isEmpty) {
      setState(() {
        labels = response.labels;
        filterMap = defaultLabels;
        for (var i = 0; i < labels.length; i++) {
          filterMap.add({"name": labels[i].labelName, "index": i + 2});
        }
      });
    }
  }

  Future<void> updateFavorite(Notes note) async {
    final response = await NotesApiProvider.updateFavorite(json.encode(
      {'id': note.noteId},
    ));
    if (response['status']) {
      setState(() {});
      if (mounted) Navigator.pop(context);
    } else {
      if (mounted) RSToast.show(context, message: response['error']);
    }
  }

  Future<void> updateColor(Notes note, int colorCode) async {
    final response = await NotesApiProvider.updateColor(json.encode(
      {'id': note.noteId, 'color': colorCode},
    ));
    if (response['status']) {
      setState(() {});
      if (mounted) Navigator.pop(context);
    } else {
      if (mounted) RSToast.show(context, message: response['error']);
    }
  }

  Future<void> deleteNote(String noteId) async {
    final response = await NotesApiProvider.delete(json.encode(
      {'id': noteId},
    ));
    if (response['status']) {
      setState(() {});
      if (mounted) Navigator.pop(context);
      if (mounted) RSToast.show(context, message: 'deleted'.tr());
    } else {
      if (mounted) RSToast.show(context, message: response['error']);
    }
  }

  @override
  void initState() {
    super.initState();
    filterMap = defaultLabels;
    getLabels();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallDevice = getScreenSize(context) == ScreenSize.small;

    return FScaffold(
      childPad: false,
      header: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: FHeader(
          title: Text(
              'welcome_message'.tr(namedArgs: {'name': globals.user.userName})),
        ),
      ),
      child: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: FSelectMenuTile(
                  initialValue: filterIndex,
                  title: Text('select'.tr()),
                  menu: filterMap.map((item) {
                    return FSelectTile(
                      value: item['index'],
                      title: Text(item['name']),
                    );
                  }).toList(),
                  detailsBuilder: (context, value, child) =>
                      Text(filterMap[filterIndex]['name']),
                  onChange: (value) {
                    setState(() {
                      filterIndex = value.first;
                    });
                  },
                ),
              ),
              FButton.icon(
                style: FButtonStyle.ghost(),
                onPress: () {},
                child: Icon(FIcons.folderCog),
              ),
              FButton(
                onPress: () => openNoteView(Notes.empty()),
                child: Text('Add'),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<NotesResult>(
              future: getNotes(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: FProgress.circularIcon(),
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
                          text: "no_notes".tr(),
                          width: MediaQuery.of(context).size.width * 0.6,
                        ),
                      );
                    }
                    return FItemGroup.builder(
                      count: snapshot.data!.notes.length,
                      divider: FItemDivider.none,
                      itemBuilder: (context, index) {
                        List<Notes> notes = snapshot.data!.notes;
                        return FItem(
                          prefix: RSTextAvatar(
                              color: NoteColor.getColor(
                                  notes[index].noteColor, false),
                              text: getInitials(notes[index].noteTitle)),
                          title: Text(notes[index].noteTitle),
                          subtitle: Row(
                            spacing: 8,
                            children: [
                              if (notes[index].noteFavorite && filterIndex != 1)
                                Icon(
                                  FIcons.heart,
                                  size: 14,
                                  color: Colors.red,
                                ),
                              Expanded(
                                child:
                                    Text(formatDateTime(notes[index].noteDate)),
                              ),
                              Expanded(
                                child: Text(
                                  notes[index].noteLabel,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          suffix: isSmallDevice
                              ? null
                              : FButton.icon(
                                  style: FButtonStyle.ghost(),
                                  onPress: () => openNoteOption(notes[index]),
                                  child: Icon(FIcons.ellipsis),
                                ),
                          onPress: () => openNoteView(notes[index]),
                          onLongPress: isSmallDevice
                              ? () => openNoteOption(notes[index])
                              : null,
                        );
                      },
                    );
                  default:
                    return Container();
                }
              },
            ),
          ),
          SizedBox(
            height: 8,
          ),
        ],
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
    showFSheet(
        context: context,
        builder: (context) => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.theme.colors.background,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12,
                children: [
                  Padding(
                    padding: kPaddingLarge,
                    child: Row(
                      children: [
                        Text(
                          note.noteTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Spacer(),
                        FButton.icon(
                          onPress: () => Navigator.pop(context),
                          child: Icon(FIcons.chevronDown),
                        ),
                      ],
                    ),
                  ),
                  FItem(
                    prefix: Icon(FIcons.heart),
                    title: Text(note.noteFavorite
                        ? 'remove_from_fav'.tr()
                        : 'set_as_fav'.tr()),
                    onPress: () => updateFavorite(note),
                  ),
                  FItem(
                    prefix: Icon(FIcons.palette),
                    title: Text('set_color'.tr()),
                    onPress: () => openColorPicker(note),
                  ),
                  FItem(
                    prefix: Icon(
                      FIcons.trash,
                      color: Colors.red,
                    ),
                    title: Text(
                      'delete'.tr(),
                      style: TextStyle(color: Colors.red),
                    ),
                    onPress: () {
                      Navigator.pop(context);
                      confirmDelete(note);
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
        side: FLayout.btt);
  }

  void confirmDelete(Notes note) async {
    showFDialog(
      context: context,
      builder: (context, style, animation) => FDialog(
        title: Text('confirm'.tr()),
        body: Text('confirm_delete'.tr()),
        actions: [
          FButton(
            onPress: () {
              deleteNote(note.noteId);
            },
            child: Text('yes'.tr()),
          ),
          FButton(
            style: FButtonStyle.outline(),
            onPress: () => Navigator.pop(context),
            child: Text('no'.tr()),
          ),
        ],
      ),
    );
  }

  void openColorPicker(Notes note) async {
    final colorCode = await showFDialog(
      context: context,
      builder: (context, style, animation) {
        return ScrawlColorPicker();
      },
    );
    if (colorCode != null) {
      updateColor(note, colorCode);
    }
  }
}
