import 'package:animations/animations.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bnotes/constants.dart';
import 'package:bnotes/helpers/adaptive.dart';
import 'package:bnotes/pages/archive_page.dart';
import 'package:bnotes/pages/home_page.dart';
import 'package:bnotes/pages/search_page.dart';
import 'package:bnotes/pages/settings_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextcloud/nextcloud.dart';
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

  final _pageList = <Widget>[
    new HomePage(title: kAppName),
    new ArchivePage(),
    new SearchPage(),
    new SettingsPage(),
  ];

  String username = '';

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
      username = sharedPreferences.getString('nc_userdisplayname') ?? '';
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
    isDesktop = isDisplayDesktop(context);
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: darkModeOn ? Colors.transparent : Colors.transparent,
    //     systemNavigationBarIconBrightness:
    //         darkModeOn ? Brightness.light : Brightness.dark,
    //     systemNavigationBarColor:
    //         darkModeOn ? Colors.transparent : Colors.transparent,
    //   ),
    // );

    if (!isDesktop) {
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
            extendBodyBehindAppBar: true,
            appBar: AppBar(
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
            // bottomNavigationBar: BottomAppBar(
            //   // color: darkModeOn ? kSecondaryDark : Colors.white,
            //   color: FlexN,
            //   child: Container(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            //     child: GNav(
            //       selectedIndex: _page,
            //       onTabChange: navigationTapped,
            //       gap: 8,
            //       activeColor: darkModeOn ? Colors.white : Colors.black,
            //       iconSize: 24,
            //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //       duration: Duration(milliseconds: 400),
            //       tabBackgroundColor: Colors.grey.withOpacity(0.1),
            //       // color: darkModeOn ? Colors.grey : Colors.grey,
            //       tabBorderRadius: 15.0,
            //       tabs: [
            //         GButton(
            //           // icon: LineIcons.stickyNoteAlt,
            //           icon: Icons.notes,
            //           text: 'Notes',
            //         ),
            //         GButton(
            //           // icon: LineIcons.archive,
            //           icon: Icons.archive_outlined,
            //           text: 'Archive',
            //         ),
            //         GButton(
            //           // icon: LineIcons.search,
            //           icon: Icons.search_outlined,
            //           text: 'Search',
            //         ),
            //         GButton(
            //           // icon: LineIcons.bars,
            //           icon: Icons.menu_rounded,
            //           text: 'More',
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            bottomNavigationBar: BottomNavigationBar(
              // showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.notes_outlined),
                  label: 'Notes',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archive',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'More',
                ),
              ],
              currentIndex: _page,
              onTap: navigationTapped,
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // SizedBox(width: 50,),
              Image.asset(
                'images/bnotes-transparent.png',
                height: 50,
              ),
              SizedBox(
                width: 20,
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
                    HomePage.staticGlobalKey.currentState!.toggleView(viewType);
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
                    HomePage.staticGlobalKey.currentState!.toggleView(viewType);
                  });
                },
              ),
            ),
          ],
        ),
        body: Container(
          child: WindowBorder(
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
                // NavigationRail(
                //   leading: openNav
                //       ? SizedBox(
                //           width: 100,
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               SizedBox(
                //                 height: 50,
                //               ),
                //               Divider(),
                //               Container(
                //                 // child: TextButton.icon(
                //                 //     onPressed: () {
                //                 //       setState(() {
                //                 //         openNav = !openNav;
                //                 //         print(openNav);
                //                 //       });
                //                 //     },
                //                 //     icon: Icon(Icons.arrow_back_ios_new),
                //                 //     label: Text('data')),
                //                 margin: EdgeInsets.only(left: 10),
                //                 child: Row(
                //                   children: [
                //                     IconButton(
                //                       icon: Icon(Icons.arrow_back_ios_new),
                //                       onPressed: () {
                //                         setState(() {
                //                           openNav = !openNav;
                //                           print(openNav);
                //                         });
                //                       },
                //                     ),
                //                     SizedBox(
                //                       width: 10,
                //                     ),
                //                     Text(
                //                       isAppLogged ? username : 'Guest',
                //                       textAlign: TextAlign.end,
                //                       overflow: TextOverflow.ellipsis,
                //                     )
                //                   ],
                //                 ),
                //               ),
                //               Divider(),
                //             ],
                //           ),
                //         )
                //       : Column(
                //           children: [
                //             SizedBox(
                //               height: 50,
                //             ),
                //             Divider(),
                //             IconButton(
                //               icon: Icon(Icons.arrow_forward_ios),
                //               onPressed: () {
                //                 setState(() {
                //                   openNav = !openNav;
                //                   print(openNav);
                //                 });
                //               },
                //             ),
                //             Divider(),
                //           ],
                //         ),
                //   extended: openNav,
                //   labelType: NavigationRailLabelType.none,
                //   destinations: <NavigationRailDestination>[
                //     NavigationRailDestination(
                //       icon: Icon(Icons.notes_rounded),
                //       label: Text('Notes'),
                //     ),
                //     NavigationRailDestination(
                //       icon: Icon(Icons.archive_outlined),
                //       label: Text('Archive'),
                //     ),
                //     NavigationRailDestination(
                //       icon: Icon(Icons.search_rounded),
                //       label: Text('Search'),
                //     ),
                //     NavigationRailDestination(
                //       icon: Icon(Icons.menu),
                //       label: Text('More'),
                //     ),
                //   ],
                //   selectedIndex: _page,
                //   // onDestinationSelected: navigationTapped,
                //   onDestinationSelected: (selectedIndex) {
                //     setState(() {
                //       _page = selectedIndex;
                //     });
                //   },
                // ),
                Container(
                  width: 250,
                  child: Drawer(
                    child: ListView(
                      children: [
                        // ListTile(
                        //   leading: SizedBox(
                        //     width: 0,
                        //   ),
                        //   title: Text(
                        //     isAppLogged ? username : 'Guest',
                        //   ),
                        // ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              _page = 0;
                            });
                          },
                          leading: Icon(Icons.notes_rounded),
                          title: Text('Notes'),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              _page = 1;
                            });
                          },
                          leading: Icon(Icons.archive_outlined),
                          title: Text('Archive'),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              _page = 2;
                            });
                          },
                          leading: Icon(Icons.search_rounded),
                          title: Text('Search'),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              _page = 3;
                            });
                          },
                          leading: Icon(Icons.menu),
                          title: Text('More'),
                        ),
                      ],
                    ),
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
