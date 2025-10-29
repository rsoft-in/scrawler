import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:http/io_client.dart' as http;
import 'package:material_symbols_icons/symbols.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/notes.dart';
import 'package:scrawler/src/screens/settings_page.dart';
import 'package:scrawler/src/widgets/rs_empty_placeholder.dart';

import '../helpers/avatar_color.dart';
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
          category: selectedCategory.toLowerCase() == "all"
              ? null
              : selectedCategory);
      notes = notesList.body.toList();
      notes.sort((a, b) {
        if (a.favorite && !b.favorite) return -1;
        if (!a.favorite && b.favorite) return 1;
        if (currentSortOn == "modified") {
          return b.modified.compareTo(a.modified);
        } else {
          return a.title.compareTo(b.title);
        }
      });
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
    categories.add('all'.tr());
    categories.addAll(notes
        .map((n) => n.category.trim())
        .where((cat) => cat.isNotEmpty)
        .toSet()
        .toList());
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
        title: Text('welcome_message'
            .tr(namedArgs: {'name': globals.userDetails!.displayName})),
        suffixes: [
          FButton.icon(
            onPress: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage())),
            style: FButtonStyle.ghost(),
            child: Icon(FIcons.user),
          ),
          SizedBox(width: 8),
        ],
      ),
      footer: Padding(
        padding: kGlobalOuterPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FButton(
              onPress: () => openNoteView(null),
              child: Text('add'.tr()),
            ),
          ],
        ),
      ),
      child: Column(
        spacing: 8,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              spacing: 8.0,
              children: [
                Expanded(
                  child: FSelectMenuTile(
                    initialValue: selectedCategory,
                    title: Text('select_category'.tr()),
                    menu: categories
                        .map((cat) => FSelectTile(
                            title:
                                Text(cat.isEmpty ? 'uncategorized'.tr() : cat),
                            value: cat))
                        .toList(),
                    detailsBuilder: (context, value, child) => categories
                            .isEmpty
                        ? Text('all'.tr())
                        : Text(value.first.isEmpty
                            ? 'uncategorized'.tr()
                            : categories.firstWhere((c) =>
                                c.toLowerCase() == value.first.toLowerCase())),
                    onChange: (value) => setState(() {
                      selectedCategory = value.first;
                      _getNotes();
                    }),
                  ),
                ),
                FPopoverMenu(
                  menuAnchor: Alignment.topRight,
                  childAnchor: Alignment.bottomRight,
                  menu: [
                    FItemGroup(children: [
                      FItem(
                        title: Text('title'.tr()),
                        onPress: () => setState(() {
                          currentSortOn = 'title';
                          _getNotes();
                        }),
                        suffix: currentSortOn == 'title'
                            ? Icon(FIcons.check)
                            : null,
                      ),
                      FItem(
                        title: Text('latest'.tr()),
                        onPress: () => setState(() {
                          currentSortOn = 'modified';
                          _getNotes();
                        }),
                        suffix: currentSortOn == 'modified'
                            ? Icon(FIcons.check)
                            : null,
                      )
                    ]),
                  ],
                  builder: (context, controller, child) => FButton.icon(
                      onPress: controller.toggle,
                      child: Icon(FIcons.listFilter)),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: 100,
                      child: FProgress(),
                    ),
                  )
                : (notes.isEmpty
                    ? Center(
                        child: EmptyWidget(text: 'no_notes'.tr(), width: 280),
                      )
                    : RefreshIndicator(
                        onRefresh: _refreshNotes,
                        child: FItemGroup.builder(
                          count: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            final modifiedDate =
                                DateTime.fromMillisecondsSinceEpoch(
                                    note.modified * 1000);
                            return FItem(
                              title: Text(note.title),
                              subtitle: Text(
                                '${formatDateTime('$modifiedDate')}${note.category.isNotEmpty ? ' | ${note.category}' : ''}',
                              ),
                              prefix: note.favorite
                                  ? FAvatar.raw(
                                      child: Icon(Symbols.star),
                                    )
                                  : FAvatar.raw(
                                      style: (style) => style.copyWith(
                                          textStyle: TextStyle(
                                            color: AvatarColor.getColor(
                                                note.title),
                                          ),
                                          backgroundColor:
                                              AvatarColor.getColor(note.title)
                                                  .withAlpha(100)),
                                      child: Text(getInitials(note.title)),
                                    ),
                              onPress: () => openNoteView(note),
                              onLongPress: () => openNoteOption(note),
                            );
                          },
                        ),
                      )),
          ),
        ],
      ),
    );
  }

  void openNoteOption(Note note) {
    showFSheet(
        context: context,
        builder: (context) => Container(
              padding: kGlobalOuterPadding,
              color: context.theme.colors.background,
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
                        FButton.icon(
                          onPress: () => Navigator.pop(context),
                          child: Icon(FIcons.x),
                        ),
                      ],
                    ),
                  ),
                  FItemGroup(children: [
                    FItem(
                      prefix: Icon(Symbols.folder),
                      title: Text('set_category'.tr()),
                      onPress: () {
                        Navigator.pop(context);
                        openCategories(note);
                      },
                    )
                  ]),
                  FItemGroup(children: [
                    FItem(
                      prefix: Icon(Symbols.star),
                      title: Text(note.favorite
                          ? 'remove_from_fav'.tr()
                          : 'set_as_fav'.tr()),
                      onPress: () {
                        Navigator.pop(context);
                        _updateFavorite(note, !note.favorite);
                      },
                    )
                  ]),
                  FItemGroup(children: [
                    FItem(
                      prefix: Icon(
                        Symbols.delete,
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
                    )
                  ]),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Text(
                'select_category'.tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              FItemGroup.builder(
                count: categories.length,
                itemBuilder: (context, index) => FItem(
                  title: Text(categories[index].isEmpty
                      ? 'uncategorized'.tr()
                      : categories[index]),
                  onPress: () {
                    Navigator.pop(context);
                    _updateCategory(note, categories[index]);
                  },
                  suffix: note.category == categories[index]
                      ? Icon(FIcons.check)
                      : null,
                ),
              ),
              FTextField(
                controller: newCategoryController,
                hint: 'enter_new_category'.tr(),
                maxLength: 20,
              ),
              FButton(
                onPress: () {
                  Navigator.pop(context);
                  _updateCategory(note, newCategoryController.text.trim());
                },
                child: Text('add_category'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void confirmDelete(Note note) async {
    showFDialog(
      context: context,
      builder: (context, style, animation) => FDialog.adaptive(
        title: Text('confirm'.tr()),
        body: Padding(
          padding: kGlobalOuterPadding,
          child: Text('confirm_delete'.tr()),
        ),
        actions: [
          FButton(
            onPress: () {
              Navigator.pop(context);
              _deleteNote(note);
            },
            child: Text('yes'.tr()),
          ),
          FButton(
            onPress: () => Navigator.pop(context),
            style: FButtonStyle.outline(),
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
