import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaru_icons/yaru_icons.dart';

class DesktopSettingsScreen extends StatefulWidget {
  const DesktopSettingsScreen({Key? key}) : super(key: key);

  @override
  State<DesktopSettingsScreen> createState() => D_SettingsStatePage();
}

// ignore: camel_case_types
class D_SettingsStatePage extends State<DesktopSettingsScreen> {
  int selectedTab = 0;
  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Container(
      padding: kGlobalOuterPadding * 2,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          // selectedTileColor:
                          //     Theme.of(context).colorScheme.surfaceVariant,
                          selected: selectedTab == 0,
                          title: const Text('Notfications'),
                          onTap: () => setState(() {
                            selectedTab = 0;
                          }),
                        ),
                        ListTile(
                          selected: selectedTab == 1,
                          title: const Text('App Lock'),
                          onTap: () => setState(() {
                            selectedTab = 1;
                          }),
                        ),
                        ListTile(
                          selected: selectedTab == 2,
                          title: const Text('About'),
                          onTap: () => setState(() {
                            selectedTab = 2;
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.centerRight,
                      child: //Icon Button
                          IconButton(
                              icon: const Icon(YaruIcons.window_close),
                              onPressed: () => Navigator.pop(context))),
                  Visibility(
                    visible: selectedTab == 0,
                    child: const Expanded(
                      child: Center(
                        child: Text(
                          'Coming soon',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: selectedTab == 1,
                    child: const Expanded(
                      child: Center(
                        child: Text(
                          'Coming soon',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: selectedTab == 2,
                    child: Expanded(
                      child: ListView(
                        children: [
                          kVSpace,
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'images/scrawler-desktop.png',
                                    height: 100,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  const Text(
                                    kAppName,
                                    style: TextStyle(fontSize: 32.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          kVSpace,
                          ListTile(
                            title: const Text(
                              'Website',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            subtitle:
                                Text(kWebsiteUrl.replaceAll('https://', '')),
                            onTap: () => _launchUrl(kWebsiteUrl),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
