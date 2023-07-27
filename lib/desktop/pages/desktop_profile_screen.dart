import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaru_icons/yaru_icons.dart';

class DesktopProfileScreen extends StatefulWidget {
  const DesktopProfileScreen({Key? key}) : super(key: key);

  @override
  State<DesktopProfileScreen> createState() => _DesktopProfileScreenState();
}

class _DesktopProfileScreenState extends State<DesktopProfileScreen> {
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
                          title: const Text('Profile Settings'),
                          onTap: () => setState(() {
                            selectedTab = 0;
                          }),
                        ),
                        ListTile(
                          selected: selectedTab == 1,
                          title: const Text('Password'),
                          onTap: () => setState(() {
                            selectedTab = 1;
                          }),
                        ),
                        ListTile(
                          selected: selectedTab == 2,
                          title: const Text('Manage Plans'),
                          onTap: () => setState(() {
                            selectedTab = 2;
                          }),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: FilledButton(
                              onPressed: signOut,
                              child: const Text('Sign Out'))),
                    ],
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
                            onPressed: () => Navigator.pop(context)),
                  ),
                  Visibility(
                    visible: selectedTab == 0,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          child: Icon(
                            YaruIcons.user,
                            size: 40,
                          ),
                        ),
                        kVSpace,
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration:
                                    InputDecoration(labelText: 'Full Name'),
                              ),
                            ),
                            kHSpace,
                            Expanded(
                              child: TextField(
                                decoration:
                                    InputDecoration(labelText: 'E-Mail'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: selectedTab == 1,
                    child: const Text('Coming soon'),
                  ),
                  Visibility(
                    visible: selectedTab == 2,
                    child: const Center(
                        child: Text(
                      'Don\'t worry you are now a free user',
                      style: TextStyle(fontSize: 24),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void signOut() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }
}
