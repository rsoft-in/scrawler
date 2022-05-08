import 'dart:convert';
import 'dart:ui';

import 'package:bnotes/common/constants.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/helpers/utility.dart';
import 'package:bnotes/models/labels_model.dart';
import 'package:bnotes/models/note_list_model.dart';
import 'package:bnotes/pages/app.dart';
import 'package:bnotes/pages/edit_note_page.dart';
import 'package:bnotes/pages/note_reader_page.dart';
import 'package:bnotes/widgets/note_card_grid.dart';
import 'package:bnotes/widgets/note_card_list.dart';
import 'package:bnotes/widgets/note_listview_ext.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/helpers/note_color.dart';
import 'package:bnotes/helpers/storage.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/pages/labels_page.dart';
import 'package:bnotes/widgets/color_palette_button.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title})
      : super(key: HomePage.staticGlobalKey);
  final String title;

  static final GlobalKey<_HomePageState> staticGlobalKey =
      new GlobalKey<_HomePageState>();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences sharedPreferences;
  bool isAppLogged = false;
  String userFullname = "";
  String userId = "";
  String userEmail = "";
  Storage storage = new Storage();
  String backupPath = "";
  late ViewType _viewType;
  ViewType viewType = ViewType.Tile;
  ScrollController scrollController = new ScrollController();
  List<Notes> notesListAll = [];
  List<Notes> notesList = [];
  List<Labels> labelList = [];
  bool isLoading = false;
  bool hasData = false;

  bool isAndroid = UniversalPlatform.isAndroid;
  bool isIOS = UniversalPlatform.isIOS;
  bool isWeb = UniversalPlatform.isWeb;
  bool isDesktop = false;
  String currentLabel = "";
  bool labelChecked = false;

  final dbHelper = DatabaseHelper.instance;
  var uuid = Uuid();
  TextEditingController _noteTitleController = new TextEditingController();
  TextEditingController _noteTextController = new TextEditingController();
  String currentEditingNoteId = "";
  TextEditingController _searchController = new TextEditingController();

  int selectedPageColor = 1;

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isAppLogged = sharedPreferences.getBool("is_logged") ?? false;
      bool isTile = sharedPreferences.getBool("is_tile") ?? false;
      _viewType = isTile ? ViewType.Tile : ViewType.Grid;
      viewType = isTile ? ViewType.Tile : ViewType.Grid;
    });
  }

  loadNotes() async {
    setState(() {
      isLoading = true;
    });

    if (isAndroid || isIOS) {
      await dbHelper.getNotesAll(_searchController.text).then((value) {
        setState(() {
          isLoading = false;
          hasData = value.length > 0;
          notesList = value;
          notesListAll = value;
        });
      });
    }
  }

  loadLabels() async {
    await dbHelper.getLabelsAll().then((value) => setState(() {
          labelList = value;
          print(labelList.length);
        }));
  }

  void toggleView(ViewType viewType) {
    setState(() {
      _viewType = viewType;
      sharedPreferences.setBool("is_tile", _viewType == ViewType.Tile);
    });
  }

  void _updateColor(String noteId, int noteColor) async {
    print(noteColor);
    await dbHelper.updateNoteColor(noteId, noteColor).then((value) {
      loadNotes();
      setState(() {
        selectedPageColor = noteColor;
      });
    });
  }

  void _archiveNote(int archive) async {
    await dbHelper.archiveNote(currentEditingNoteId, archive).then((value) {
      loadNotes();
    });
  }

  void _deleteNote() async {
    await dbHelper.deleteNotes(currentEditingNoteId).then((value) {
      loadNotes();
    });
  }

  void _filterNotes() {
    setState(() {
      notesList = notesListAll.where((element) {
        return element.noteLabel.contains(currentLabel);
      }).toList();
    });
  }

  void _clearFilterNotes() {
    setState(() {
      notesList = notesListAll;
    });
  }

  @override
  void initState() {
    getPref();
    loadNotes();
    loadLabels();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    print(globals.themeMode);
    isDesktop = isDisplayDesktop(context);
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 100.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Notes',
                  style: TextStyle(
                    color: darkModeOn ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                titlePadding: EdgeInsets.only(left: 30, bottom: 15),
              ),
              actions: [
                Visibility(
                  visible: viewType == ViewType.Tile,
                  child: IconButton(
                    icon: Icon(Iconsax.grid_3),
                    onPressed: () {
                      setState(() {
                        viewType = ViewType.Grid;
                        HomePage.staticGlobalKey.currentState!
                            .toggleView(viewType);
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: viewType == ViewType.Grid,
                  child: IconButton(
                    icon: Icon(Iconsax.row_vertical),
                    onPressed: () {
                      setState(() {
                        viewType = ViewType.Tile;
                        HomePage.staticGlobalKey.currentState!
                            .toggleView(viewType);
                      });
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    icon: Icon(Iconsax.filter))
              ],
            ),
          ];
        },
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : (hasData
                        ? (_viewType == ViewType.Grid
                            ? Container(
                                margin: isPortrait
                                    ? EdgeInsets.zero
                                    : EdgeInsets.symmetric(horizontal: 200),
                                child: StaggeredGridView.countBuilder(
                                  crossAxisCount: isDesktop ? 4 : 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 0,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: notesList.length,
                                  staggeredTileBuilder: (index) {
                                    return StaggeredTile.count(
                                        1, index.isOdd ? 0.9 : 1.02);
                                  },
                                  itemBuilder: (context, index) {
                                    var note = notesList[index];
                                    List<NoteListItem> _noteList = [];
                                    if (note.noteList.contains('{')) {
                                      try {
                                        final parsed = json
                                            .decode(note.noteText)
                                            .cast<Map<String, dynamic>>();
                                        _noteList = parsed
                                            .map<NoteListItem>((json) =>
                                                NoteListItem.fromJson(json))
                                            .toList();
                                      } on Exception catch (e) {
                                        // TODO
                                      }
                                    }
                                    return NoteCardGrid(
                                      note: note,
                                      onTap: () {
                                        setState(() {
                                          selectedPageColor = note.noteColor;
                                        });
                                        _showNoteReader(context, note);
                                      },
                                      onLongPress: () {
                                        _showOptionsSheet(context, note);
                                      },
                                    );
                                  },
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                margin: isDesktop
                                    ? EdgeInsets.symmetric(horizontal: 200)
                                    : EdgeInsets.all(0),
                                child: ListView.builder(
                                  itemCount: notesList.length,
                                  physics: BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  itemBuilder: (context, index) {
                                    var note = notesList[index];
                                    List<NoteListItem> _noteList = [];
                                    if (note.noteList.contains('{')) {
                                      final parsed = json
                                          .decode(note.noteText)
                                          .cast<Map<String, dynamic>>();
                                      _noteList = parsed
                                          .map<NoteListItem>((json) =>
                                              NoteListItem.fromJson(json))
                                          .toList();
                                    }
                                    return NoteCardList(
                                      note: note,
                                      onTap: () {
                                        setState(() {
                                          selectedPageColor = note.noteColor;
                                        });
                                        _showNoteReader(context, note);
                                      },
                                      onLongPress: () {
                                        _showOptionsSheet(context, note);
                                      },
                                    );
                                  },
                                ),
                              ))
                        : Container(
                            alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 150,
                                ),
                                Icon(
                                  Iconsax.note_1,
                                  size: 120,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'empty!',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 22),
                                ),
                              ],
                            ),
                          )),
              ),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: darkModeOn
                    ? FlexColor.jungleDarkPrimary.lighten(10).withOpacity(0.5)
                    : FlexColor.jungleDarkPrimary.lighten(5).withOpacity(0.5),
              ),
              padding: EdgeInsets.only(left: 15, top: 56, bottom: 20),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Icon(Iconsax.filter),
                  SizedBox(
                    width: 32,
                  ),
                  Text(
                    'Filter Labels',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            if (labelList.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.tag,
                        size: 80,
                        color: FlexColor.jungleDarkPrimaryVariant,
                      ),
                      SizedBox(height: 20),
                      Text('No labels created'),
                      TextButton(
                          onPressed: () {
                            openLabelEditor();
                          },
                          child: Text('Create labels')),
                    ],
                  ),
                ),
              ),
            if (labelList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    Labels label = labelList[index];
                    return ListTile(
                      onTap: (() {
                        setState(() {
                          currentLabel = label.labelName;
                          _filterNotes();
                        });
                      }),
                      leading: Icon(Iconsax.tag),
                      trailing: (currentLabel.isEmpty ||
                              currentLabel != label.labelName)
                          ? Icon(
                              Icons.clear,
                              color: Colors.transparent,
                            )
                          : Icon(
                              Icons.check_outlined,
                              color: FlexColor.jungleDarkPrimary,
                            ),
                      title: Text(label.labelName),
                    );
                  },
                  itemCount: labelList.length,
                ),
              ),
            if (labelList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: darkModeOn
                      ? FlexColor.jungleDarkSecondary
                          .lighten(20)
                          .withOpacity(0.5)
                      : FlexColor.jungleDarkSecondary
                          .lighten(30)
                          .withOpacity(0.5),
                  trailing: Icon(Iconsax.close_square),
                  title: Text('Clear Filter'),
                  onTap: () {
                    setState(() {
                      currentLabel = "";
                      _filterNotes();
                    });
                    Navigator.pop(context);
                  },
                  dense: true,
                ),
              ),
            if (labelList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: darkModeOn
                      ? FlexColor.jungleDarkSecondary
                          .lighten(5)
                          .withOpacity(0.5)
                      : FlexColor.jungleDarkSecondary
                          .lighten(10)
                          .withOpacity(0.5),
                  trailing: Icon(Iconsax.tag),
                  title: Text('Manage Labels'),
                  onTap: () {
                    Navigator.pop(context);
                    openLabelEditor();
                  },
                  dense: true,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        onPressed: () {
          setState(() {
            _noteTextController.text = '';
            _noteTitleController.text = '';
            currentEditingNoteId = "";
          });
          _showEdit(context, new Notes('', '', '', '', '', 0, 0, ''));
        },
        child: Icon(Iconsax.add),
      ),
    );
  }

  void openLabelEditor() async {
    var res = await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new LabelsPage(
              noteid: '',
              notelabel: '',
            )));
    loadLabels();
  }

  openDialog(Widget page) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: darkModeOn ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: darkModeOn ? Colors.white24 : Colors.black12,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Container(
                decoration: BoxDecoration(
                  color: darkModeOn ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(
                    maxWidth: 600,
                    minWidth: 400,
                    minHeight: 600,
                    maxHeight: 600),
                padding: EdgeInsets.all(8),
                child: page),
          );
        });
  }

  void _showOptionsSheet(BuildContext context, Notes _note) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    isDesktop = isDisplayDesktop(context);
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        constraints: isDesktop
            ? BoxConstraints(maxWidth: 450, minWidth: 400)
            : BoxConstraints(),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: 480,
                child: Container(
                  child: Padding(
                    padding: kGlobalOuterPadding,
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _noteTextController.text =
                                  Utility.stripTags(_note.noteText);
                              _noteTitleController.text = _note.noteTitle;
                              currentEditingNoteId = _note.noteId;
                            });
                            _showEdit(context, _note);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Iconsax.edit_2),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Edit'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          // onTap: () {
                          //   Navigator.pop(context);
                          //   _showColorPalette(context, _note);
                          // },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Iconsax.color_swatch),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Color Palette'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 60,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                ColorPaletteButton(
                                  color: NoteColor.getColor(0, darkModeOn),
                                  onTap: () {
                                    _updateColor(_note.noteId, 0);
                                    Navigator.pop(context);
                                  },
                                  isSelected: _note.noteColor == 0,
                                ),
                                ColorPaletteButton(
                                  color: NoteColor.getColor(1, darkModeOn),
                                  onTap: () {
                                    _updateColor(_note.noteId, 1);
                                    Navigator.pop(context);
                                  },
                                  isSelected: _note.noteColor == 1,
                                ),
                                ColorPaletteButton(
                                  color: NoteColor.getColor(2, darkModeOn),
                                  onTap: () {
                                    _updateColor(_note.noteId, 2);
                                    Navigator.pop(context);
                                  },
                                  isSelected: _note.noteColor == 2,
                                ),
                                ColorPaletteButton(
                                  color: NoteColor.getColor(3, darkModeOn),
                                  onTap: () {
                                    _updateColor(_note.noteId, 3);
                                    Navigator.pop(context);
                                  },
                                  isSelected: _note.noteColor == 3,
                                ),
                                ColorPaletteButton(
                                  color: NoteColor.getColor(4, darkModeOn),
                                  onTap: () {
                                    _updateColor(_note.noteId, 4);
                                    Navigator.pop(context);
                                  },
                                  isSelected: _note.noteColor == 4,
                                ),
                                ColorPaletteButton(
                                  color: NoteColor.getColor(5, darkModeOn),
                                  onTap: () {
                                    _updateColor(_note.noteId, 5);
                                    Navigator.pop(context);
                                  },
                                  isSelected: _note.noteColor == 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.pop(context);
                            _assignLabel(_note);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Iconsax.tag),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Assign Labels'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _note.noteArchived == 0,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                currentEditingNoteId = _note.noteId;
                              });
                              _archiveNote(1);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Iconsax.archive_add),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Archive'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _note.noteArchived == 1,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                currentEditingNoteId = _note.noteId;
                              });
                              _archiveNote(0);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Iconsax.archive_minus),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Unarchive'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() {
                              currentEditingNoteId = _note.noteId;
                            });
                            _confirmDelete();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Iconsax.note_remove),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Iconsax.close_circle),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Cancel'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  void _showNoteReader(BuildContext context, Notes _note) async {
    isDesktop = isDisplayDesktop(context);
    if (isDesktop) {
      bool res = await showDialog(
          context: context,
          builder: (context) {
            return Container(
              child: Dialog(
                child: Container(
                  width: isDesktop ? 800 : MediaQuery.of(context).size.width,
                  child: NoteReaderPage(
                    note: _note,
                  ),
                ),
              ),
            );
          });
      if (res) loadNotes();
    } else {
      bool res = await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new NoteReaderPage(
                note: _note,
              )));
      if (res) loadNotes();
    }
  }

  void _confirmDelete() async {
    isDesktop = isDisplayDesktop(context);
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        constraints: isDesktop
            ? BoxConstraints(maxWidth: 450, minWidth: 400)
            : BoxConstraints(),
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Padding(
              padding: kGlobalOuterPadding,
              child: Container(
                height: 160,
                child: Padding(
                  padding: kGlobalOuterPadding,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: kGlobalCardPadding,
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: kGlobalCardPadding,
                        child: Text('Are you sure you want to delete?'),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: kGlobalCardPadding,
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('No'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: kGlobalCardPadding,
                              child: ElevatedButton(
                                onPressed: () {
                                  _deleteNote();
                                  Navigator.pop(context, true);
                                },
                                child: Text('Yes'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _assignLabel(Notes note) async {
    var res = await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new LabelsPage(
              noteid: note.noteId,
              notelabel: note.noteLabel,
            )));
    if (res != null) loadNotes();
  }

  void _showEdit(BuildContext context, Notes _note) async {
    if (!UniversalPlatform.isDesktop) {
      final res = await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new EditNotePage(
                note: _note,
              )));

      if (res is Notes) loadNotes();
    } else {
      openDialog(EditNotePage(
        note: _note,
      ));
    }
  }

  // Future<bool> _onBackPressed() async {
  //   if (!(_noteTitleController.text.isEmpty ||
  //       _noteTextController.text.isEmpty)) {
  //     _saveNote();
  //   }
  //   return true;
  // }

  String getDateString() {
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime dt = DateTime.now();
    return formatter.format(dt);
  }
}
