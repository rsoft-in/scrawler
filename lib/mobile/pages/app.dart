import 'package:bnotes/common/adaptive.dart';
import 'package:bnotes/common/constants.dart';
import 'package:bnotes/helpers/database_helper.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:bnotes/mobile/pages/archive_page.dart';
import 'package:bnotes/mobile/pages/notes_page.dart';
import 'package:bnotes/mobile/pages/search_page.dart';
import 'package:bnotes/mobile/pages/settings_page.dart';
import 'package:bnotes/models/labels_model.dart';
import 'package:bnotes/models/notes_model.dart';
import 'package:bnotes/widgets/appbar.dart';
import 'package:bnotes/widgets/note_card_grid.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

enum ViewType { Tile, Grid }

class ScrawlApp extends StatefulWidget {
  const ScrawlApp({Key? key}) : super(key: key);

  @override
  _ScrawlAppState createState() => _ScrawlAppState();
}

class _ScrawlAppState extends State<ScrawlApp> {
  late SharedPreferences sharedPreferences;
  bool isTileView = false;
  ViewType viewType = ViewType.Tile;
  bool isAppLogged = false;
  String appPin = "";
  bool openNav = false;

  bool isAndroid = UniversalPlatform.isAndroid;
  bool isIOS = UniversalPlatform.isIOS;
  bool isWeb = UniversalPlatform.isWeb;
  bool isDesktop = false;

  late PageController _pageController;
  int _page = 0;
  final dbHelper = DatabaseHelper.instance;
  List<Notes> notesListAll = [];
  List<Notes> notesList = [];
  List<Labels> labelList = [];
  bool isLoading = false;
  bool hasData = false;
  int selectedPageColor = 1;

  final _pageList = <Widget>[
    new NotesPage(),
    new ArchivePage(),
    new SearchPage(),
    new SettingsPage(),
  ];

  String username = 'User';

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isAppLogged = sharedPreferences.getBool("is_logged") ?? false;
      appPin = sharedPreferences.getString("app_pin") ?? '';
      bool isTile = sharedPreferences.getBool("is_tile") ?? false;
      username = sharedPreferences.getString('nc_userdisplayname') ?? 'User';
      print(appPin);
      viewType = isTile ? ViewType.Tile : ViewType.Grid;
    });
  }

  Future getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    // if (isAppLogged) {
    //   try {
    //     final client = NextCloudClient.withCredentials(
    //       Uri(host: sharedPreferences.getString('nc_host')),
    //       sharedPreferences.getString('nc_username') ?? '',
    //       sharedPreferences.getString('nc_password') ?? '',
    //     );
    //     final userData = await client.avatar.getAvatar(
    //         sharedPreferences.getString('nc_username').toString(), 150);
    //     sharedPreferences.setString('nc_avatar', userData);

    //     // ignore: unnecessary_null_comparison
    //   } on RequestException catch (e, stacktrace) {
    //     print('qs' + e.statusCode.toString());
    //     print(e.body);
    //     print(stacktrace);
    //     ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    //       behavior: SnackBarBehavior.floating,
    //       content: Text('Unable to login. Try again.'),
    //       duration: Duration(seconds: 2),
    //     ));
    //   }
    // }
    loadNotes();
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  loadNotes() async {
    setState(() {
      isLoading = true;
    });

    if (isAndroid || isIOS) {
      await dbHelper.getNotesAll('').then((value) {
        setState(() {
          isLoading = false;
          hasData = value.length > 0;
          notesList = value;
          notesListAll = value;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
    getdata();
    _pageController = new PageController();
  }

  Future<bool> onWillPop() async {
    if (_pageController.page!.round() == _pageController.initialPage) {
      sharedPreferences.setBool("is_app_unlocked", false);
      return true;
    } else {
      _pageController.jumpToPage(_pageController.initialPage);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    isDesktop = isDisplayDesktop(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: darkModeOn ? Colors.transparent : Colors.transparent,
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        systemNavBarStyle: FlexSystemNavBarStyle.background,
        useDivider: false,
        opacity: 0,
      ),
      child: WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: Scaffold(
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  username: username,
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text('All Notes', style: TextStyle(fontSize: 16)),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: NotesPage(),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            icon: Icon(Icons.add),
            label: Text('Add new note'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            backgroundColor: darkModeOn ? Colors.white : kScaffoldDark,
            foregroundColor: darkModeOn ? kScaffoldDark : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget notesGrid() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: notesList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var note = notesList[index];
        return NoteCardGrid(
          note: note,
          onTap: () {
            setState(() {
              selectedPageColor = note.noteColor;
            });
            // _showNoteReader(context, note);
          },
          onLongPress: () {
            // _showOptionsSheet(context, note);
          },
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }
}
