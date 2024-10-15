import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:scrawler/helpers/globals.dart' as globals;
import 'package:scrawler/helpers/theme_notifier.dart';
import 'package:scrawler/widgets/icon_color.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  bool isLightColor(Color color) {
    // Calculate the luminance of the color
    double luminance = color.computeLuminance();
    return luminance >
        0.5; // if luminance is greater than 0.5, it's a light color
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...globals.appColors.map(
                    (color) {
                      return InkWell(
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          // Add this later
                          // child: IconColorBasedOnBackground(
                          //     backgroundColor: color,
                          //     iconData: Symbols.check_circle),
                        ),
                      );
                    },
                  ),
                ],
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
                            borderRadius: BorderRadius.circular(kBorderRadius)),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 20),
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
                            borderRadius: BorderRadius.circular(kBorderRadius)),
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
                            borderRadius: BorderRadius.circular(kBorderRadius)),
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
    );
  }
}
