import 'package:animations/animations.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bnotes/constants.dart';
import 'package:bnotes/pages/archive_page.dart';
import 'package:bnotes/pages/home_page.dart';
import 'package:bnotes/pages/search_page.dart';
import 'package:bnotes/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:yaru_icons/widgets/yaru_icons.dart';

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

  bool isAndroid = UniversalPlatform.isAndroid;
  bool isIOS = UniversalPlatform.isIOS;
  bool isWeb = UniversalPlatform.isWeb;
  bool isDesktop = UniversalPlatform.isDesktop;

  late PageController _pageController;
  int _page = 0;

  final _pageList = <Widget>[
    new HomePage(title: kAppName),
    new ArchivePage(),
    new SearchPage(),
    new SettingsPage(),
  ];

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
      print(appPin);
      viewType = isTile ? ViewType.Tile : ViewType.Grid;
    });
  }

  Future getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (isAppLogged) {
      try {
        final client = NextCloudClient.withCredentials(
          Uri(host: sharedPreferences.getString('nc_host')),
          sharedPreferences.getString('nc_username') ?? '',
          sharedPreferences.getString('nc_password') ?? '',
        );
        final userData = await client.avatar.getAvatar(
            sharedPreferences.getString('nc_username').toString(), 150);
        sharedPreferences.setString('nc_avatar', userData);

        // ignore: unnecessary_null_comparison
      } on RequestException catch (e, stacktrace) {
        print('qs' + e.statusCode.toString());
        print(e.body);
        print(stacktrace);
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: Text('Unable to login. Try again.'),
          duration: Duration(seconds: 2),
        ));
      }
    }
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
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
    bool darkModeOn = brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: darkModeOn ? Colors.transparent : Colors.transparent,
        systemNavigationBarIconBrightness:
            darkModeOn ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            darkModeOn ? kSecondaryDark : Colors.transparent,
      ),
    );
    if (isAndroid || isIOS) {
      return WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 56),
            child: Visibility(
              child: AppBar(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'images/bnotes-transparent.png',
                      height: 50,
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          kAppName,
                          style: TextStyle(fontFamily: 'Raleway'),
                        )),
                  ],
                ),
                actions: [
                  Visibility(
                    visible: viewType == ViewType.Tile && _page == 0,
                    child: IconButton(
                      icon: Icon(Icons.grid_view_outlined),
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
                    visible: viewType == ViewType.Grid && _page == 0,
                    child: IconButton(
                      icon: Icon(Icons.view_agenda_outlined),
                      onPressed: () {
                        setState(() {
                          viewType = ViewType.Tile;
                          HomePage.staticGlobalKey.currentState!
                              .toggleView(viewType);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            pageSnapping: false,
            children: [
              new HomePage(title: kAppName),
              new ArchivePage(),
              new SearchPage(),
              new SettingsPage(),
            ],
            onPageChanged: onPageChanged,
            controller: _pageController,
          ),
          bottomNavigationBar: BottomAppBar(
            color: darkModeOn ? kSecondaryDark : Colors.white,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                selectedIndex: _page,
                onTabChange: navigationTapped,
                gap: 8,
                activeColor: darkModeOn ? Colors.white : Colors.black,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey.withOpacity(0.1),
                color: darkModeOn ? Colors.grey : Colors.grey,
                tabBorderRadius: 15.0,
                tabs: [
                  GButton(
                    // icon: LineIcons.stickyNoteAlt,
                    icon: Icons.notes,
                    text: 'Notes',
                  ),
                  GButton(
                    // icon: LineIcons.archive,
                    icon: Icons.archive_outlined,
                    text: 'Archive',
                  ),
                  GButton(
                    // icon: LineIcons.search,
                    icon: Icons.search_outlined,
                    text: 'Search',
                  ),
                  GButton(
                    // icon: LineIcons.bars,
                    icon: Icons.menu_rounded,
                    text: 'More',
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size(100, 40),
        //   child: MoveWindow(
        //     child: AppBar(
        //       actions: [
        //         IconButton(
        //           onPressed: () {
        //             appWindow.minimize();
        //           },
        //           icon: Icon(YaruIcons.window_minimize),
        //         ),
        //         IconButton(
        //           onPressed: () {
        //             appWindow.maximize();
        //           },
        //           icon: Icon(YaruIcons.window_maximize),
        //         ),
        //         IconButton(
        //           onPressed: () {
        //             appWindow.close();
        //           },
        //           icon: Icon(YaruIcons.window_close),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: WindowBorder(
          color: Colors.transparent,
          width: 1,
          child: Row(
            children: [
              // SizedBox(
              //   width: 200,
              //   child: Container(
              //     color: Colors.red,
              //     child: Column(
              //       children: [
              //         WindowTitleBarBox(
              //           child: MoveWindow(),
              //         ),
              //         // Expanded(child: Container()),
              //       ],
              //     ),
              //   ),
              // ),
              Container(
                color: darkModeOn ? kSecondaryDark : Colors.grey[100],
                child: Column(
                  children: [
                    Container(
                      padding: kGlobalOuterPadding,
                      child: Image.asset(
                        'images/bnotes-transparent.png',
                        height: 50,
                      ),
                    ),
                    Expanded(
                      child: NavigationRail(
                        backgroundColor:
                            darkModeOn ? kSecondaryDark : Colors.grey[100],
                        labelType: NavigationRailLabelType.selected,
                        destinations: <NavigationRailDestination>[
                          NavigationRailDestination(
                            icon: Icon(Icons.notes_rounded),
                            label: Text('Notes'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.archive_outlined),
                            label: Text('Archive'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.search_rounded),
                            label: Text('Search'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.settings_outlined),
                            label: Text('Settings'),
                          ),
                        ],
                        selectedIndex: _page,
                        // onDestinationSelected: navigationTapped,
                        onDestinationSelected: (selectedIndex) {
                          setState(() {
                            _page = selectedIndex;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: PageTransitionSwitcher(
                        transitionBuilder:
                            (child, animation, secondaryAnimation) {
                          return FadeThroughTransition(
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                            child: child,
                            fillColor:
                                darkModeOn ? kScaffoldDark : Colors.white,
                          );
                        },
                        child: _pageList[_page],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class WindowButtons extends StatelessWidget {
  final buttonColors = WindowButtonColors(
      iconNormal: kPrimaryColor,
      mouseOver: Colors.black12,
      mouseDown: Colors.black12,
      iconMouseOver: kPrimaryColor,
      iconMouseDown: kPrimaryColor);

  final closeButtonColors = WindowButtonColors(
      mouseOver: Colors.black12,
      mouseDown: Colors.black12,
      iconNormal: kPrimaryColor,
      iconMouseOver: Colors.red,
      iconMouseDown: Colors.red);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
