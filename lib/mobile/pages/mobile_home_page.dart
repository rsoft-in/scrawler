import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/dbhelper.dart';
import 'package:bnotes/helpers/string_values.dart';
import 'package:bnotes/mobile/pages/mobile_notes_page.dart';
import 'package:bnotes/mobile/pages/mobile_settings_page.dart';
import 'package:bnotes/mobile/pages/mobile_tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({Key? key}) : super(key: key);

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  final dbHelper = DBHelper.instance;
  int selectedTab = 0;
  late PageController pageController;

  void pageChanged(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  void onTabChanged(int index) {
    setState(() {
      selectedTab = index;
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      pageController = PageController(
        initialPage: selectedTab,
        keepPage: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: kMenuMobile.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => onTabChanged(index),
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 50),
                    style: TextStyle(
                      color: darkModeOn ? Colors.white : Colors.black,
                      fontSize: index == selectedTab ? 22.0 : 18.0,
                      fontWeight: index == selectedTab
                          ? FontWeight.w500
                          : FontWeight.w300,
                    ),
                    child: Text(
                      kLabels[kMenuMobile[index]['text']]!,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: pageChanged,
        children: const [
          MobileNotesPage(),
          MobileTasksPage(),
          MobileSettingsPage()
        ],
      ),
    );
  }
}
