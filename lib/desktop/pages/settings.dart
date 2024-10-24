import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/helpers/globals.dart' as globals;
import 'package:scrawler/helpers/theme_notifier.dart';
import 'package:scrawler/widgets/icon_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 70,
                  ),
                  BackButton(),
                  kHSpace,
                  const Text(
                    'Settings',
                    style: TextStyle(
                      // fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              kVSpace,
              TabBar(
                isScrollable: true,
                indicatorWeight: 2,
                tabs: [
                  Tab(
                    icon: Icon(Symbols.dark_mode),
                    text: 'Appearance',
                  ),
                  Tab(
                    icon: Icon(Symbols.info),
                    text: 'About',
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    appearanceView(),
                    aboutView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget aboutView() {
    return SingleChildScrollView(
      child: ListTile(
        title: const Text('About this app'),
        onTap: () => showAboutDialog(
            context: context,
            applicationName: kAppName,
            applicationVersion: kAppVersion,
            applicationLegalese: 'RSoft',
            applicationIcon: Image.asset(
              'images/scrawler-desktop.png',
              scale: 6,
            )),
      ),
    );
  }

  Widget appearanceView() {
    return Consumer<ThemeNotifier>(
      builder: (context, themeProvider, child) => Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                ListTile(
                  title: Text('App Color'),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // List.generate(globals.appColors.length, (color) {
                      //   return Container();
                      // }),
                      ...globals.appColors.map(
                        (color) {
                          bool isSelectedColor =
                              color == themeProvider.selectedPrimaryColor;
                          return InkWell(
                            onTap: isSelectedColor
                                ? null
                                : () {
                                    themeProvider
                                        .setSelectedPrimaryColor(color);
                                    // setPrefs(color);
                                  },
                            child: Container(
                              width: 50,
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              // Add this later
                              child: isSelectedColor
                                  ? IconColorBasedOnBackground(
                                      backgroundColor: color,
                                      iconData: Symbols.check_circle)
                                  : null,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                kVSpace,
                ListTile(
                  title: Text('Theme'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Material(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius)),
                          child: InkWell(
                            onTap: () {
                              ThemeNotifier themeNotifier =
                                  Provider.of<ThemeNotifier>(context,
                                      listen: false);
                              if (themeNotifier.themeMode == ThemeMode.dark ||
                                  themeNotifier.themeMode == ThemeMode.system) {
                                themeNotifier.setTheme(ThemeMode.light);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  Icon(Symbols.sunny),
                                  kVSpace,
                                  Text('Light'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      kHSpace,
                      Expanded(
                        child: Material(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius)),
                          child: InkWell(
                            onTap: () {
                              ThemeNotifier themeNotifier =
                                  Provider.of<ThemeNotifier>(context,
                                      listen: false);
                              if (themeNotifier.themeMode == ThemeMode.light ||
                                  themeNotifier.themeMode == ThemeMode.system) {
                                themeNotifier.setTheme(ThemeMode.dark);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  Icon(Symbols.bedtime),
                                  kVSpace,
                                  Text('Dark'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      kHSpace,
                      Expanded(
                        child: Material(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius)),
                          child: InkWell(
                            onTap: () {
                              ThemeNotifier themeNotifier =
                                  Provider.of<ThemeNotifier>(context,
                                      listen: false);
                              if (themeNotifier.themeMode == ThemeMode.light ||
                                  themeNotifier.themeMode == ThemeMode.dark) {
                                themeNotifier.setTheme(ThemeMode.system);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  Icon(Symbols.smartphone),
                                  kVSpace,
                                  Text('System'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  setPrefs(Color seedColor) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setInt('selected_seed_color', seedColor.value);
  }
}
