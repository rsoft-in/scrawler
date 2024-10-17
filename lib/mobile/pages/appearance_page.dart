import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/helpers/globals.dart' as globals;
import 'package:scrawler/helpers/theme_notifier.dart';
import 'package:scrawler/widgets/icon_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  late SharedPreferences prefs;
  bool isLightColor(Color color) {
    // Calculate the luminance of the color
    double luminance = color.computeLuminance();
    return luminance >
        0.5; // if luminance is greater than 0.5, it's a light color
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeProvider, child) => Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              title: const Text('Appearance'),
              centerTitle: true,
            ),
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
