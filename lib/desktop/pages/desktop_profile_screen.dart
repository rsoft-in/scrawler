import 'package:bnotes/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                          selectedTileColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          selected: selectedTab == 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kGlobalBorderRadius)),
                          title: const Text('Profile Settings'),
                          onTap: () => setState(() {
                            selectedTab = 0;
                          }),
                        ),
                        ListTile(
                          selected: selectedTab == 1,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kGlobalBorderRadius)),
                          title: const Text('Password'),
                          onTap: () => setState(() {
                            selectedTab = 1;
                          }),
                        ),
                        ListTile(
                          selected: selectedTab == 2,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kGlobalBorderRadius)),
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
                    child: CloseButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Visibility(
                    visible: selectedTab == 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          child: Icon(
                            Icons.person_outlined,
                            size: 40,
                          ),
                        ),
                        kVSpace,
                        Row(
                          children: const [
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
                    child: const Text('Password'),
                  ),
                  Visibility(
                    visible: selectedTab == 2,
                    child: const Text('Manage Plans'),
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