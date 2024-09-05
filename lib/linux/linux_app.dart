import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_window_manager/libadwaita_window_manager.dart';
import 'package:scrawler/helpers/constants.dart';

class LinuxApp extends StatefulWidget {
  const LinuxApp({super.key});

  @override
  State<LinuxApp> createState() => _LinuxAppState();
}

class _LinuxAppState extends State<LinuxApp> {
  late FlapController _flapController;
  int currentIndex = 0;
  final developers = {
      'Nandan': 'suranjum',
      'Rajesh': 'nahnah',
    };

  @override
  void initState() {
    super.initState();
    _flapController = FlapController();
    _flapController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return AdwScaffold(
      flapController: _flapController,
      actions: AdwActions().windowManager,
      title: const Text(kAppName),
      start: [
        AdwHeaderButton(
          icon: const Icon(Icons.view_sidebar_outlined, size: 19),
          isActive: _flapController.isOpen,
          onPressed: () => _flapController.toggle(),
        ),
      ],
      flap: (isDrawer) => AdwSidebar(
        currentIndex: currentIndex,
        onSelected: (index) => setState(() {
          currentIndex = index;
        }),
        children: const [
          AdwSidebarItem(
            label: 'Notes',
          ),
          AdwSidebarItem(
            label: 'Settings',
          ),
        ],
      ),
      end: [
        GtkPopupMenu(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdwButton.flat(
                onPressed: () {
                  
                  Navigator.of(context).pop();
                },
                padding: AdwButton.defaultButtonPadding.copyWith(
                  top: 10,
                  bottom: 10,
                ),
                child: const Text(
                  'Reset Counter',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Divider(),
              AdwButton.flat(
                padding: AdwButton.defaultButtonPadding.copyWith(
                  top: 10,
                  bottom: 10,
                ),
                child: const Text(
                  'Preferences',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              AdwButton.flat(
                padding: AdwButton.defaultButtonPadding.copyWith(
                  top: 10,
                  bottom: 10,
                ),
                onPressed: () => showDialog<Widget>(
                  context: context,
                  builder: (ctx) => AdwAboutWindow(
                    issueTrackerLink:
                        'https://github.com/gtk-flutter/libadwaita/issues',
                    appIcon: Image.asset('assets/logo.png'),
                    credits: [
                      AdwPreferencesGroup.creditsBuilder(
                        title: 'Developers',
                        itemCount: developers.length,
                        itemBuilder: (_, index) => AdwActionRow(
                          title: developers.keys.elementAt(index),
                          // onActivated: () => launchUrl(
                          //   Uri.parse(
                          //     'https://github.com/${developers.values.elementAt(index)}',
                          //   ),
                          // ),
                        ),
                      ),
                    ],
                    copyright: 'Copyright 2021-2022 Gtk-Flutter Developers',
                    license: const Text(
                      'GNU LGPL-3.0, This program comes with no warranty.',
                    ),
                  ),
                ),
                child: const Text(
                  'About this Demo',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ],
      body: AdwViewStack(
        animationDuration: const Duration(milliseconds: 100),
        index: currentIndex,
        children: const [
          Center(
            child: Text('Notes'),
          ),
          Center(
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
