import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart' as http;
import 'package:material_symbols_icons/symbols.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/notes.dart';
import 'package:scrawler/src/helpers/avatar_color.dart';
import 'package:scrawler/src/screens/settings_page.dart';
import 'package:scrawler/src/widgets/rs_empty_placeholder.dart';

import '../helpers/constants.dart';
import '../helpers/globals.dart' as globals;
import '../helpers/utility.dart';
import '../widgets/rs_toast.dart';
import 'note_view_page.dart';

class NotesPage extends StatefulWidget {
  final String server;
  final String username;
  final String password;
  final http.IOClient? client;
  const NotesPage(
      {super.key,
      required this.server,
      required this.username,
      required this.password,
      required this.client});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late NextcloudClient ncClient;
  List<String> categories = [];
  List<Note> notes = [];
  bool isLoading = false;
  TextEditingController newCategoryController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'all';
  String currentSortOn = 'modified';

  Future<void> _getNotes() async {
    setState(() {
      isLoading = true;
    });
    try {
      ncClient = NextcloudClient(
        Uri.parse(widget.server),
        loginName: widget.username,
        password: widget.password,
        httpClient: widget.client,
      );
      final notesList = await ncClient.notes.getNotes(
          category: selectedCategory == "all" ? null : selectedCategory);
      notes = notesList.body.toList();
      if (selectedCategory == "all") getCategories(notes);
      setState(() {});
    } catch (e) {
      if (mounted) {
        RSToast.show(context, message: '$e');
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getCategories(List<Note> notes) {
    categories.clear();
    categories = notes
        .map((n) => n.category.trim())
        .where((cat) => cat.isNotEmpty)
        .toSet()
        .toList();
    categories.add('');
  }

  Future<void> _updateFavorite(Note note, bool value) async {
    try {
      ncClient = NextcloudClient(
        Uri.parse(widget.server),
        loginName: widget.username,
        password: widget.password,
        httpClient: widget.client,
      );
      await ncClient.notes.updateNote(
          id: note.id,
          favorite: value ? 1 : 0,
          modified: (DateTime.now().millisecondsSinceEpoch / 1000).round());
      _getNotes();
    } catch (e) {
      if (mounted) {
        RSToast.show(context, message: '$e');
      }
    }
  }

  Future<void> _updateCategory(Note note, String value) async {
    try {
      ncClient = NextcloudClient(
        Uri.parse(widget.server),
        loginName: widget.username,
        password: widget.password,
        httpClient: widget.client,
      );
      await ncClient.notes.updateNote(
          id: note.id,
          category: value,
          modified: (DateTime.now().millisecondsSinceEpoch / 1000).round());
      _getNotes();
    } catch (e) {
      if (mounted) {
        RSToast.show(context, message: '$e');
      }
    }
  }

  Future<void> _deleteNote(Note note) async {
    try {
      ncClient = NextcloudClient(
        Uri.parse(widget.server),
        loginName: widget.username,
        password: widget.password,
        httpClient: widget.client,
      );
      await ncClient.notes.deleteNote(id: note.id);
      _getNotes();
    } catch (e) {
      if (mounted) {
        RSToast.show(context, message: '$e');
      }
    }
  }

  Future<void> _refreshNotes() async => _getNotes();

  @override
  void initState() {
    super.initState();
    _getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('welcome_message'
            .tr(namedArgs: {'name': globals.userDetails!.displayName})),
        actions: [
          IconButton.filledTonal(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage())),
            icon: Icon(Symbols.person),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        spacing: 8,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 8.0, left: 8, right: 8, bottom: 4),
            child: Row(
              spacing: 8.0,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    hint: Text('select_category'.tr()),
                    borderRadius: BorderRadius.circular(kGlobalBorderRadius),
                    items: [
                      DropdownMenuItem(value: 'all', child: Text('all'.tr())),
                      ...categories.map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat.isEmpty ? 'uncategorized'.tr() : cat))),
                    ],
                    onChanged: (value) => setState(() {
                      selectedCategory = value!;
                      _getNotes();
                    }),
                  ),
                ),
                PopupMenuButton<String>(
                  initialValue: currentSortOn,
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    PopupMenuItem(
                      value: 'title',
                      child: Text('title'.tr()),
                    ),
                    PopupMenuItem(
                      value: 'modified',
                      child: Text('latest'.tr()),
                    ),
                  ],
                  icon: Icon(Symbols.sort),
                  onSelected: (value) {
                    setState(() {
                      currentSortOn = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: 100,
                      child: LinearProgressIndicator(),
                    ),
                  )
                : (notes.isEmpty
                    ? Center(
                        child: EmptyWidget(text: 'no_notes'.tr(), width: 280),
                      )
                    : RefreshIndicator(
                        onRefresh: _refreshNotes,
                        child: ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            final modifiedDate =
                                DateTime.fromMillisecondsSinceEpoch(
                                    note.modified * 1000);
                            return ListTile(
                              title: Text(note.title),
                              subtitle: Text(
                                '${formatDateTime('$modifiedDate')}${note.category.isNotEmpty ? ' | ${note.category}' : ''}',
                              ),
                              leading: note.favorite
                                  ? CircleAvatar(
                                      child: Icon(Symbols.star),
                                    )
                                  : CircleAvatar(
                                      foregroundColor:
                                          AvatarColor.getColor(note.title),
                                      backgroundColor:
                                          AvatarColor.getColor(note.title)
                                              .withAlpha(100),
                                      child: Text(getInitials(note.title)),
                                    ),
                              onTap: () => openNoteView(note),
                              onLongPress: () => openNoteOption(note),
                            );
                          },
                        ),
                      )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteView(null),
        child: Icon(Symbols.add),
      ),
    );
  }

  void openNoteOption(Note note) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: kGlobalOuterPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: kPaddingLarge,
              child: Row(
                children: [
                  Text(
                    note.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Spacer(),
                  CloseButton(
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Symbols.folder),
              title: Text('set_category'.tr()),
              onTap: () {
                Navigator.pop(context);
                openCategories(note);
              },
            ),
            ListTile(
              leading: Icon(Symbols.star),
              title: Text(
                  note.favorite ? 'remove_from_fav'.tr() : 'set_as_fav'.tr()),
              onTap: () {
                Navigator.pop(context);
                _updateFavorite(note, !note.favorite);
              },
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
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  void openCategories(Note note) {
    newCategoryController.clear();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: kGlobalOuterPadding,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Text(
                  'select'.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(categories[index].isEmpty
                        ? 'uncategorized'.tr()
                        : categories[index]),
                    onTap: () {
                      Navigator.pop(context);
                      _updateCategory(note, categories[index]);
                    },
                  ),
                ),
                TextField(
                  controller: newCategoryController,
                  decoration: InputDecoration(
                    hintText: 'enter_new_category'.tr(),
                    counterText: '',
                  ),
                  maxLength: 20,
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _updateCategory(note, newCategoryController.text.trim());
                  },
                  child: Text('add_category'.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void confirmDelete(Note note) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('confirm'.tr()),
        content: Text('confirm_delete'.tr()),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteNote(note);
            },
            child: Text('yes'.tr()),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('no'.tr()),
          ),
        ],
      ),
    );
  }

  Future<void> openNoteView(Note? note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteView(
          server: widget.server,
          username: widget.username,
          password: widget.password,
          client: widget.client,
          note: note,
        ),
      ),
    );
    if (result) {
      _getNotes();
    }
  }
}
