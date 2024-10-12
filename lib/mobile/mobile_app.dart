import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/helpers/note_color.dart';
import 'package:scrawler/helpers/utility.dart';
import 'package:scrawler/mobile/dbhelper.dart';
import 'package:scrawler/mobile/pages/mobile_note_edit.dart';
import 'package:scrawler/models/notes.dart';
import 'package:scrawler/widgets/scrawl_alert_dialog.dart';
import 'package:scrawler/widgets/scrawl_empty.dart';

class MobileApp extends StatefulWidget {
  const MobileApp({super.key});

  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  List<Notes> notes = [];
  final dbHelper = DBHelper();
  SearchController searchController = SearchController();
  late PageController pageController =
      PageController(initialPage: 0, keepPage: true);
  int currentPageIndex = 0;

  Future<void> getNotes() async {
    notes = await dbHelper.getNotesAll('', 'note_date DESC');
    setState(() {});
  }

  Future<void> saveColor(String noteId, int noteColor) async {
    final res = await dbHelper.updateNoteColor(noteId, noteColor);
    if (res) {
      setState(() {
        final index = notes.indexWhere((n) => n.noteId == noteId);
        notes[index].noteColor = noteColor;
      });
    } else {
      print('Unable to save note color!');
    }
  }

  Future<void> setAsFavorite(String noteId, bool value) async {
    final res = await dbHelper.updateNoteFavorite(noteId, value);
    if (res) {
      setState(() {
        final index = notes.indexWhere((n) => n.noteId == noteId);
        notes[index].noteFavorite = value;
      });
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      print('Unable to save note color!');
    }
  }

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppName),
        actions: [
          SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return IconButton(
                icon: const Icon(Symbols.search),
                onPressed: () => controller.openView(),
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              final List<Notes> suggestions = notes
                  .where((n) => n.noteTitle
                      .toLowerCase()
                      .contains(controller.text.toLowerCase()))
                  .toList();

              return List<ListTile>.generate(
                suggestions.length,
                (int index) {
                  return ListTile(
                    title: Text(suggestions[index].noteTitle),
                    onTap: () {
                      setState(() {
                        controller.closeView(suggestions[index].noteTitle);
                        controller.clear();
                      });
                      openNote(suggestions[index], false, true);
                    },
                  );
                },
              );
            },
          ),
          IconButton(onPressed: () {}, icon: const Icon(Symbols.account_circle))
        ],
      ),
      body: notes.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: EmptyWidget(
                  text: 'No Notes',
                  width: MediaQuery.of(context).size.width,
                  asset: 'images/undraw_playful_cat.svg'),
            )
          : PageView(
              controller: pageController,
              onPageChanged: (value) => setState(() {
                currentPageIndex = value;
              }),
              children: [
                dash(),
                myNote(),
              ],
            ),
      bottomNavigationBar: notes.isEmpty
          ? null
          : NavigationBar(
              onDestinationSelected: onNavigate,
              selectedIndex: currentPageIndex,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Symbols.home),
                  label: 'Home',
                  selectedIcon: Icon(
                    Symbols.home,
                    fill: 1,
                  ),
                ),
                NavigationDestination(
                  icon: Icon(Symbols.note_stack),
                  label: 'My Notes',
                  selectedIcon: Icon(
                    Symbols.note_stack,
                    fill: 1,
                  ),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNote(Notes.empty(), true, false),
        child: const Icon(Symbols.add),
      ),
    );
  }

  void onNavigate(int index) {
    setState(() {
      currentPageIndex = index;
    });
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
  }

  Widget dash() {
    final recentNotes = notes.sublist(0, notes.length > 5 ? 5 : notes.length);
    final favNotes = notes
        .where(
          (element) => element.noteFavorite,
        )
        .toList();
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                'Favourites',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            kVSpace,
            favNotes.isEmpty
                ? const Center(
                    child: Text('It\'s empty'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: favNotes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: InkWell(
                          borderRadius:
                              BorderRadius.circular(kGlobalBorderRadius),
                          onTap: () => openNote(favNotes[index], false, true),
                          onLongPress: () => onNoteLongPressed(favNotes[index]),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 4),
                                width: 5,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: NoteColor.getColor(
                                      favNotes[index].noteColor, false),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(favNotes[index].noteTitle),
                                  subtitle: Text(Utility.formatDateTime(
                                      favNotes[index].noteDate)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            kVSpace,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                'Recents',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            kVSpace,
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentNotes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(kGlobalBorderRadius),
                    onTap: () => openNote(recentNotes[index], false, true),
                    onLongPress: () => onNoteLongPressed(recentNotes[index]),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          width: 5,
                          height: 50,
                          decoration: BoxDecoration(
                            color: NoteColor.getColor(
                                recentNotes[index].noteColor, false),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(recentNotes[index].noteTitle),
                            subtitle: Text(Utility.formatDateTime(
                                recentNotes[index].noteDate)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget myNote() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(kGlobalBorderRadius),
                    onTap: () => openNote(notes[index], false, true),
                    onLongPress: () => onNoteLongPressed(notes[index]),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          width: 5,
                          height: 50,
                          decoration: BoxDecoration(
                            color: NoteColor.getColor(
                                notes[index].noteColor, false),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(notes[index].noteTitle),
                            subtitle: Text(notes[index].noteDate),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void openNote(Notes note, bool isNew, bool readMode) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileNoteEdit(
          note: note,
          isNewNote: isNew,
          readMode: readMode,
        ),
      ),
    );
    if (result) {
      getNotes();
    }
  }

  Future<void> onDeleteClicked(Notes note) async {
    showDialog(
      context: context,
      builder: (context) {
        return ScrawlConfirmDialog(
          title: 'Delete?',
          content: 'Are you sure?',
          onAcceptPressed: () {
            Navigator.pop(context);
            deleteNote(note);
          },
        );
      },
    );
  }

  Future<void> deleteNote(Notes note) async {
    await dbHelper.deleteNotes(note.noteId);
    if (mounted) Navigator.pop(context);

    getNotes();
  }

  void onNoteLongPressed(Notes note) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: kGlobalOuterPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  leading: Icon(Symbols.folder_copy),
                  title: Text('Move to Folder'),
                ),
                ListTile(
                  leading: const Icon(Symbols.favorite),
                  title: Text(
                      '${note.noteFavorite ? 'Remove from' : 'Add to'}  Favorites'),
                  onTap: () => setAsFavorite(note.noteId, !note.noteFavorite),
                ),
                const ListTile(
                  leading: Icon(Symbols.palette),
                  title: Text('Change Color'),
                ),
                SizedBox(
                  height: 50,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    const SizedBox(
                      width: 48,
                    ),
                    ...NoteColor.colorSet.map((colorSet) => InkWell(
                          onTap: () => changeColor(note, colorSet.code),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: colorSet.color,
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                            ),
                            child: note.noteColor == colorSet.code
                                ? const Icon(Symbols.check_circle)
                                : null,
                          ),
                        )),
                  ]),
                ),
                const ListTile(
                  leading: Icon(Symbols.archive),
                  title: Text('Archive'),
                ),
                ListTile(
                  leading: const Icon(Symbols.delete),
                  title: const Text('Delete'),
                  onTap: () => onDeleteClicked(note),
                ),
              ],
            ),
          );
        });
  }

  void changeColor(Notes note, int colorCode) async {
    if (mounted) {
      Navigator.pop(context);
    }
    saveColor(note.noteId, colorCode);
  }
}
