import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:http/io_client.dart' as http;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/notes.dart';
import 'package:scrawler/src/helpers/avatar_color.dart';
import 'package:scrawler/src/widgets/rs_avatar.dart';

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
      final notesList = await ncClient.notes.getNotes();
      notes = notesList.body.toList();
      getCategories(notes);
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
    return FScaffold(
      childPad: false,
      header: FHeader.nested(
        titleAlignment: Alignment.centerLeft,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text('welcome_message'
              .tr(namedArgs: {'name': globals.userDetails!.displayName})),
        ),
        suffixes: [
          FButton.icon(
            onPress: () => _getNotes(),
            style: FButtonStyle.ghost(),
            child: Icon(FIcons.refreshCcw),
          ),
        ],
      ),
      footer: Padding(
        padding: kGlobalOuterPadding,
        child: Row(
          spacing: 8,
          children: [
            Expanded(
              child: FTextField(
                controller: searchController,
                hint: 'search'.tr(),
                onEditingComplete: () {},
              ),
            ),
            FButton.icon(
              onPress: () => openNoteView(null),
              style: FButtonStyle.primary(),
              child: Icon(FIcons.plus),
            ),
          ],
        ),
      ),
      child: isLoading
          ? Center(
              child: SizedBox(
                width: 100,
                child: FProgress(),
              ),
            )
          : (notes.isEmpty
              ? Center(
                  child: Text('No Notes'),
                )
              : RefreshIndicator(
                  onRefresh: _refreshNotes,
                  child: FItemGroup.builder(
                    count: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final modifiedDate = DateTime.fromMillisecondsSinceEpoch(
                          note.modified * 1000);
                      return FItem(
                        title: Text(note.title),
                        subtitle: Text(
                          '${formatDateTime('$modifiedDate')}${note.category.isNotEmpty ? ' | ${note.category}' : ''}',
                        ),
                        prefix: note.favorite
                            ? FAvatar.raw(
                                child: Icon(
                                FIcons.star,
                                color: Colors.amber,
                              ))
                            : RSTextAvatar(
                                text: getInitials(note.title),
                                color: AvatarColor.getColor(note.title),
                              ),
                        onPress: () => openNoteView(note),
                        onLongPress: () => openNoteOption(note),
                      );
                    },
                  ),
                )),
    );
  }

  void openNoteOption(Note note) {
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
                spacing: 8,
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
                        FButton.icon(
                          onPress: () => Navigator.pop(context),
                          child: Icon(FIcons.chevronDown),
                        ),
                      ],
                    ),
                  ),
                  FItem(
                    prefix: Icon(FIcons.folder),
                    title: Text('Set Category'),
                    onPress: () {
                      Navigator.pop(context);
                      openCategories(note);
                    },
                  ),
                  FItem(
                    prefix: Icon(
                      FIcons.star,
                      color: Colors.amber,
                    ),
                    title: Text(note.favorite
                        ? 'remove_from_fav'.tr()
                        : 'set_as_fav'.tr()),
                    onPress: () {
                      Navigator.pop(context);
                      _updateFavorite(note, !note.favorite);
                    },
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

  void openCategories(Note note) {
    newCategoryController.clear();
    showFDialog(
      context: context,
      builder: (context, style, animation) => FDialog.raw(
        builder: (context, style) => Padding(
          padding: kGlobalOuterPadding,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Text(
                  'Select',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                FTileGroup(
                  children: categories
                      .map((cat) => FTile(
                            title: Text(cat.isEmpty ? 'Uncategorized' : cat),
                            onPress: () {
                              Navigator.pop(context);
                              _updateCategory(note, cat);
                            },
                          ))
                      .toList(),
                ),
                FTextField(
                  controller: newCategoryController,
                  hint: 'Enter new category',
                  maxLength: 20,
                ),
                FButton(
                  onPress: () {
                    Navigator.pop(context);
                    _updateCategory(note, newCategoryController.text.trim());
                  },
                  child: Text('Add Category'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void confirmDelete(Note note) async {
    showFDialog(
      context: context,
      builder: (context, style, animation) => FDialog(
        title: Text('confirm'.tr()),
        body: Text('confirm_delete'.tr()),
        actions: [
          FButton(
            onPress: () {
              Navigator.pop(context);
              _deleteNote(note);
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
