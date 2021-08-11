import 'package:bnotes/constants.dart';
import 'package:bnotes/pages/archive_page.dart';
import 'package:bnotes/pages/home_page.dart';
import 'package:bnotes/pages/search_page.dart';
import 'package:bnotes/pages/settings_page.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  late PageController _pageController;
  int _page = 0;

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      bool isTile = sharedPreferences.getBool("is_tile") ?? false;
      viewType = isTile ? ViewType.Tile : ViewType.Grid;
    });
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    getPref();
    _pageController = new PageController();
  }

  bool onWillPop() {
    if (_pageController.page!.round() == _pageController.initialPage)
      return true;
    else {
      _pageController.jumpToPage(
        _pageController.initialPage
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: () => Future.sync(onWillPop),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
        bottomNavigationBar: BottomBar(
          backgroundColor: darkModeOn ? kSecondaryDark : Colors.transparent,
          textStyle: TextStyle(fontWeight: FontWeight.w400),
          onTap: navigationTapped,
          selectedIndex: _page,
          items: <BottomBarItem>[
            BottomBarItem(
              icon: Icon(Icons.notes_rounded),
              title: Text('Notes'),
              activeColor: Colors.teal,
            ),
            BottomBarItem(
              icon: Icon(Icons.archive_outlined),
              title: Text('Archive'),
              activeColor: Colors.orange,
              darkActiveColor: Colors.orange.shade400, // Optional
            ),
            BottomBarItem(
              icon: Icon(Icons.search_rounded),
              title: Text('Search'),
              activeColor: Colors.blue,
              darkActiveColor: Colors.blue.shade400, // Optional
            ),
            BottomBarItem(
              icon: Icon(Icons.menu_rounded),
              title: Text('Settings'),
              activeColor: kSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
