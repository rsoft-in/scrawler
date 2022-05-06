import 'package:bnotes/pages/app.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  late PageController _pageController;
  late SharedPreferences prefs;
  bool newUser = true;

  int _page = 0;

  void navigationForward(int page) {
    _pageController.animateToPage(page + 1,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    // _pageController.jumpToPage(page);
  }

  void navigationBackward(int page) {
    _pageController.animateToPage(page - 1,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    // _pageController.jumpToPage(page);
  }

  getPref() async {
    prefs = await SharedPreferences.getInstance();
    newUser = prefs.getBool('newUser') ?? true;
  }

  @override
  void initState() {
    super.initState();
    getPref();
    _pageController = new PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade900,
            FlexColor.jungleDarkPrimary,
          ],
        ),
      ),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: FlexColorScheme.themedSystemNavigationBar(
          context,
          systemNavBarStyle: FlexSystemNavBarStyle.background,
          useDivider: false,
          opacity: 0,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: PageView(
            children: [
              ScreenOne(),
              ScreenTwo(),
            ],
            controller: _pageController,
            onPageChanged: onPageChanged,
            physics: BouncingScrollPhysics(),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_page != 0)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.white,
                          side: BorderSide(color: Colors.white),
                        ),
                        onPressed: () {
                          navigationBackward(_page);
                        },
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.back),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Back'),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {
                        navigationForward(_page);
                        if (_page == 1) {
                          Navigator.of(context).pushAndRemoveUntil(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new ScrawlApp()),
                              (Route<dynamic> route) => false);
                          newUser = false;
                          prefs.setBool('newUser', false);
                        }
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text('Next'),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(CupertinoIcons.forward),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenOne extends StatefulWidget {
  const ScreenOne({Key? key}) : super(key: key);

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(
            'images/bnotes.png',
            height: 80,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          'Welcome to',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        Text(
          'scrawl',
          style: TextStyle(fontSize: 50, color: Colors.white),
        ),
      ],
    );
  }
}

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({Key? key}) : super(key: key);

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 80),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Iconsax.note,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 30),
            Text(
              'Take Notes Easily',
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Divider(
              color: Colors.white,
              thickness: 1,
            ),
            SizedBox(height: 30),
            Icon(
              Iconsax.add_circle,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              'Create notes',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 10),
            Divider(
              color: Colors.white,
              thickness: 1,
              indent: 40,
              endIndent: 40,
            ),
            SizedBox(height: 10),
            Icon(
              Iconsax.tag,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              'Label them',
              style: TextStyle(fontSize: 20, color: Colors.grey.shade300),
            ),
            SizedBox(height: 10),
            Divider(
              color: Colors.white,
              thickness: 1,
              indent: 40,
              endIndent: 40,
            ),
            SizedBox(height: 10),
            Icon(
              Iconsax.document_download,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              'Backup them',
              style: TextStyle(fontSize: 20, color: Colors.grey.shade300),
            ),
          ],
        ),
      ),
    );
  }
}
