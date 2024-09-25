import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/desktop/pages/desktop_note_edit.dart';
import 'package:scrawler/desktop/pages/desktop_note_view.dart';
import 'package:scrawler/desktop/pages/settings.dart';
import 'package:scrawler/helpers/adaptive.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/helpers/dbhelper.dart';
import 'package:scrawler/helpers/utility.dart';
import 'package:scrawler/models/notes.dart';
import 'package:scrawler/widgets/rs_alert_dialog.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/globals.dart' as globals;

class DesktopApp extends StatefulWidget {
  const DesktopApp({super.key});

  @override
  State<DesktopApp> createState() => _DesktopAppState();
}

class _DesktopAppState extends State<DesktopApp> with TickerProviderStateMixin {
  bool editorMode = false;
  bool showSidebar = true;
  bool isNewNote = false;
  final dbHelper = DBHelper.instance;
  List<Notes> notes = [];
  Notes? selectedNote;
  bool darkModeOn = false;
  bool isLargeDevice = false;

  Future<void> getNotes() async {
    notes = await dbHelper.getNotesAll('', 'note_title');
    setState(() {});
  }

  void onNoteSelected(Notes note) {
    setState(() {
      selectedNote = note;
      editorMode = false;
      isNewNote = false;
    });
  }

  Future<void> saveNote(Notes note, bool isNew) async {
    if (isNew) {
      await dbHelper.insertNotes(note);
    } else {
      await dbHelper.updateNotes(note);
    }
    getNotes();
    setState(() {
      selectedNote = note;
      editorMode = false;
      isNewNote = false;
    });
  }

  Future<void> deleteNote() async {
    await dbHelper.deleteNotes(selectedNote!.noteId);
    setState(() {
      selectedNote = null;
    });
    getNotes();
  }

  showSettings() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return const Dialog.fullscreen(
          child: SettingsPage(),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (globals.themeMode == ThemeMode.system &&
            brightness == Brightness.dark));
    isLargeDevice = getScreenSize(context) == ScreenSize.large;
    // return Scaffold(
    //   body: Row(
    //     children: [
    //       SizedBox(
    //         width: 250,
    //         child: Padding(
    //           padding: kPaddingMedium,
    //           child: Column(
    //             mainAxisSize: MainAxisSize.max,
    //             crossAxisAlignment: CrossAxisAlignment.stretch,
    //             children: [
    //               const SizedBox(
    //                 height: 35,
    //               ),
    //               FilledButton.tonal(
    //                 style: FilledButton.styleFrom(
    //                   padding: const EdgeInsets.all(16),
    //                 ),
    //                 onPressed: () => setState(() {
    //                   Notes newNote = Notes.empty();
    //                   newNote.noteId = const Uuid().v1();
    //                   selectedNote = newNote;
    //                   isNewNote = true;
    //                   editorMode = true;
    //                 }),
    //                 child: const Row(
    //                   children: [
    //                     Icon(Symbols.add),
    //                     kHSpace,
    //                     Text('Add Note'),
    //                   ],
    //                 ),
    //               ),
    //               const Divider(
    //                 thickness: 0.2,
    //               ),
    //               Expanded(
    //                 child: ListView.builder(
    //                   itemCount: notes.length,
    //                   itemBuilder: (context, index) {
    //                     return ListTile(
    //                       leading: const Icon(Symbols.note),
    //                       title: Text(notes[index].noteTitle),
    //                       onTap: () => onNoteSelected(notes[index]),
    //                       selected: selectedNote?.noteId == notes[index].noteId,
    //                       selectedTileColor: kPrimaryColor.withOpacity(0.2),
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(kBorderRadius),
    //                       ),
    //                     );
    //                   },
    //                 ),
    //               ),
    //               ListTile(
    //                 leading: const Icon(Symbols.settings),
    //                 title: const Text('Settings'),
    //                 onTap: () => showSettings(),
    //                 shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(kBorderRadius)),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       selectedNote != null
    //           ? Expanded(
    //               child: editorMode
    //                   ? Card(
    //                       elevation: 5,
    //                       child: DesktopNoteEdit(
    //                         note: selectedNote!,
    //                         onSave: (note, isNew) {
    //                           saveNote(note, isNew);
    //                         },
    //                         isNewNote: isNewNote,
    //                       ),
    //                     )
    //                   : Card(
    //                       elevation: 5,
    //                       semanticContainer: false,
    //                       child: DesktopNoteView(
    //                         note: selectedNote!,
    //                         onEditClicked: () {
    //                           setState(() {
    //                             editorMode = true;
    //                             isNewNote = false;
    //                           });
    //                         },
    //                         onDeleteClicked: () {
    //                           Future.delayed(const Duration(microseconds: 500),
    //                               () {
    //                             if (mounted) {
    //                               showDialog(
    //                                   context: context,
    //                                   builder: (context) {
    //                                     return RSAlertDialog(
    //                                       title: const Text('Confirm'),
    //                                       content: const Text(
    //                                           'Are you sure you want to Delete?'),
    //                                       acceptText: 'Yes',
    //                                       rejectText: 'No',
    //                                       onAcceptAction: () => deleteNote(),
    //                                     );
    //                                   });
    //                             }
    //                           });
    //                         },
    //                       ),
    //                     ),
    //             )
    //           : const Expanded(
    //               child: Center(
    //                 child: Text('Select a Note'),
    //               ),
    //             ),
    //     ],
    //   ),
    // );
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.superKey, LogicalKeyboardKey.slash):
            const SidebarIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          SidebarIntent: SetCounterAction(perform: () {
            // _searchNode.requestFocus();
            print('object');
          }),
        },
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(showSidebar ? 4.0 : 0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: selectedNote != null
                  ? Scaffold(
                      key: const ValueKey<int>(1),
                      body: Row(
                        children: [
                          Visibility(
                              visible: showSidebar, child: buildSidebar()),
                          Expanded(
                            child: Card(
                              elevation: 5,
                              semanticContainer: false,
                              child: editorMode
                                  ? DesktopNoteEdit(
                                      note: selectedNote!,
                                      onSave: (note, isNew) {
                                        saveNote(note, isNew);
                                      },
                                      isNewNote: isNewNote,
                                    )
                                  : DesktopNoteView(
                                      note: selectedNote!,
                                      onEditClicked: () {
                                        setState(() {
                                          editorMode = true;
                                          isNewNote = false;
                                        });
                                      },
                                      onDeleteClicked: () {
                                        Future.delayed(
                                            const Duration(microseconds: 500),
                                            () {
                                          if (mounted) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return RSAlertDialog(
                                                  title: const Text('Confirm'),
                                                  content: const Text(
                                                      'Are you sure you want to Delete?'),
                                                  acceptText: 'Yes',
                                                  rejectText: 'No',
                                                  onAcceptAction: () {
                                                    deleteNote();
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              },
                                            );
                                          }
                                        });
                                      },
                                      onSidebarClicked: () {
                                        setState(() {
                                          showSidebar = !showSidebar;
                                        });
                                      },
                                      showSidebar: showSidebar,
                                    ),
                            ),
                          ),
                          // Expanded(
                          //   child: editorMode
                          //       ? Card(
                          //           elevation: 5,
                          //           semanticContainer: false,
                          //           child: DesktopNoteEdit(
                          //             note: selectedNote!,
                          //             onSave: (note, isNew) {
                          //               saveNote(note, isNew);
                          //             },
                          //             isNewNote: isNewNote,
                          //           ),
                          //         )
                          //       : Card(
                          //           elevation: 5,
                          //           semanticContainer: false,
                          //           child: DesktopNoteView(
                          //             note: selectedNote!,
                          //             onEditClicked: () {
                          //               setState(() {
                          //                 editorMode = true;
                          //                 isNewNote = false;
                          //               });
                          //             },
                          //             onDeleteClicked: () {
                          //               Future.delayed(
                          //                   const Duration(microseconds: 500),
                          //                   () {
                          //                 if (mounted) {
                          //                   showDialog(
                          //                     context: context,
                          //                     builder: (context) {
                          //                       return RSAlertDialog(
                          //                         title: const Text('Confirm'),
                          //                         content: const Text(
                          //                             'Are you sure you want to Delete?'),
                          //                         acceptText: 'Yes',
                          //                         rejectText: 'No',
                          //                         onAcceptAction: () {
                          //                           deleteNote();
                          //                           Navigator.pop(context);
                          //                         },
                          //                       );
                          //                     },
                          //                   );
                          //                 }
                          //               });
                          //             },
                          //             onSidebarClicked: () {
                          //               setState(() {
                          //                 showSidebar = !showSidebar;
                          //               });
                          //             },
                          //           ),
                          //         ),
                          // )
                        ],
                      ),
                    )
                  : Scaffold(
                      key: const ValueKey<int>(0),
                      body: gridViewBuilder(),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSidebar() {
    return SizedBox(
      width: 250,
      child: Padding(
        padding: kPaddingMedium,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (UniversalPlatform.isMacOS)
              const SizedBox(
                height: 35,
              ),
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Symbols.search),
                hintText: 'Search Notes',
              ),
              onChanged: (value) {
                // Implement search logic
              },
            ),
            const SizedBox(
              height: 4,
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              onPressed: () => setState(() {
                selectedNote = null;
              }),
              child: const Row(
                children: [
                  Icon(Symbols.home),
                  kHSpace,
                  Text('Home'),
                ],
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              onPressed: () => setState(() {
                Notes newNote = Notes.empty();
                newNote.noteId = const Uuid().v1();
                selectedNote = newNote;
                isNewNote = true;
                editorMode = true;
              }),
              child: const Row(
                children: [
                  Icon(Symbols.add),
                  kHSpace,
                  Text('Add Note'),
                ],
              ),
            ),
            const Divider(
              thickness: 0.2,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Symbols.note),
                    title: Text(notes[index].noteTitle),
                    onTap: () => onNoteSelected(notes[index]),
                    selected: selectedNote?.noteId == notes[index].noteId,
                    selectedTileColor: kPrimaryColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Symbols.settings),
              title: const Text('Settings'),
              onTap: () => showSettings(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kBorderRadius)),
            ),
          ],
        ),
      ),
    );
  }

  Widget gridViewBuilder() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1000,
          minHeight: 600,
        ),
        child: Padding(
          padding: kPaddingLarge,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (UniversalPlatform.isMacOS)
                const SizedBox(
                  height: 30,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Symbols.home),
                  kHSpace,
                  const Text(
                    'Home',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                      onPressed: () => showSettings(),
                      icon: const Icon(Symbols.settings))
                ],
              ),
              kVSpace,
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search Notes',
                ),
                onChanged: (value) {
                  // Implement search logic
                },
              ),
              kVSpace,
              Expanded(
                child: Card(
                  child: Padding(
                    padding: kPaddingMedium,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        kVSpace,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Text(
                            'Recents',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        kVSpace,
                        Expanded(
                          child: GridView.builder(
                            itemCount: notes.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isLargeDevice ? 4 : 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: isLargeDevice ? 1.8 : 2.5,
                            ),
                            itemBuilder: (context, index) {
                              return Card.filled(
                                child: InkWell(
                                  onTap: () => onNoteSelected(notes[index]),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: kPaddingLarge,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          notes[index].noteTitle,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          Utility.formatDateTime(
                                              notes[index].noteDate),
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SidebarIntent extends Intent {
  const SidebarIntent();
}

class SetCounterAction extends Action {
  final Function perform;

  SetCounterAction({required this.perform});

  @override
  Object? invoke(Intent intent) {
    debugPrint("Shortcut Called");
    return perform();
  }
}