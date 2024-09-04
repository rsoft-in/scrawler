import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:scrawler/windows/settings_page.dart';

class WindowsApp extends StatefulWidget {
  const WindowsApp({super.key});

  @override
  State<WindowsApp> createState() => _WindowsAppState();
}

class _WindowsAppState extends State<WindowsApp> {
  int topIndex = 0;
  fluent.PaneDisplayMode displayMode = fluent.PaneDisplayMode.auto;

  static const notesList = <String>[
    'Note 1',
    'Note 2',
    'Note 3',
    'Note 4',
  ];

  List<fluent.NavigationPaneItem> items = [
    fluent.PaneItemAction(
        tileColor: fluent.WidgetStatePropertyAll(fluent.Colors.blue),
        icon: const Icon(fluent.FluentIcons.add),
        title: const Text('New note'),
        onTap: () {
          // Function to add new note
        }),
    fluent.PaneItemSeparator(),
    fluent.PaneItem(
      icon: const Icon(fluent.FluentIcons.issue_tracking),
      title: const Text('Note one'),
      body: const _NavigationBodyItem(
        header: 'Badging',
        content: Text('Sample'),
      ),
    ),
    fluent.PaneItem(
      icon: const Icon(fluent.FluentIcons.disable_updates),
      title: const Text('Disabled Item'),
      body: const _NavigationBodyItem(),
      enabled: false,
    ),
    fluent.PaneItemExpander(
      icon: const Icon(fluent.FluentIcons.account_management),
      title: const Text('Account'),
      body: const _NavigationBodyItem(
        header: 'PaneItemExpander',
        content: Text(
          'Some apps may have a more complex hierarchical structure '
          'that requires more than just a flat list of navigation '
          'items. You may want to use top-level navigation items to '
          'display categories of pages, with children items displaying '
          'specific pages. It is also useful if you have hub-style '
          'pages that only link to other pages. For these kinds of '
          'cases, you should create a hierarchical NavigationView.',
        ),
      ),
      items: [
        fluent.PaneItemHeader(header: const Text('Apps')),
        fluent.PaneItem(
          icon: const Icon(fluent.FluentIcons.mail),
          title: const Text('Mail'),
          body: const _NavigationBodyItem(),
        ),
        fluent.PaneItem(
          icon: const Icon(fluent.FluentIcons.calendar),
          title: const Text('Calendar'),
          body: const _NavigationBodyItem(),
        ),
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return fluent.NavigationView(
      appBar: const fluent.NavigationAppBar(
        title: Text('scrawler'),
      ),
      pane: fluent.NavigationPane(
        selected: topIndex,
        size: const fluent.NavigationPaneSize(
            openMinWidth: 100, openMaxWidth: 280),
        autoSuggestBoxReplacement: const Icon(fluent.FluentIcons.search),
        onItemPressed: (index) {
          // Do anything you want to do, such as:
          if (index == topIndex) {
            if (displayMode == fluent.PaneDisplayMode.open) {
              setState(() => displayMode = fluent.PaneDisplayMode.compact);
            } else if (displayMode == fluent.PaneDisplayMode.compact) {
              setState(() => displayMode = fluent.PaneDisplayMode.open);
            }
          }
        },
        onChanged: (index) => setState(() => topIndex = index),
        displayMode: displayMode,
        items: items,
        autoSuggestBox: fluent.AutoSuggestBox<String>(
          placeholder: 'Search notes',
          items: notesList.map((notesList) {
            return fluent.AutoSuggestBoxItem<String>(
                value: notesList,
                label: notesList,
                onFocusChange: (focused) {
                  if (focused) {
                    debugPrint('Focused $notesList');
                  }
                });
          }).toList(),
          onSelected: (item) {
            // setState(() => selected = item);
          },
        ),
        footerItems: [
          fluent.PaneItem(
            icon: const Icon(fluent.FluentIcons.settings),
            title: const Text('Settings'),
            body: const Win_Settings_Page(),
          ),
          // fluent.PaneItemAction(
          //   icon: const Icon(fluent.FluentIcons.add),
          //   title: const Text('Add New Item'),
          //   onTap: () {
          //     // Your Logic to Add New `NavigationPaneItem`
          //     items.add(
          //       fluent.PaneItem(
          //         icon: const Icon(fluent.FluentIcons.new_folder),
          //         title: const Text('New Item'),
          //         body: const Center(
          //           child: Text(
          //             'This is a newly added Item',
          //           ),
          //         ),
          //       ),
          //     );
          //     setState(() {});
          //   },
          // ),
        ],
      ),
    );
  }
}

class _NavigationBodyItem extends StatelessWidget {
  const _NavigationBodyItem({
    this.header,
    this.content,
  });

  final String? header;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return fluent.ScaffoldPage.withPadding(
      header: fluent.PageHeader(title: Text(header ?? 'This is a header text')),
      content: content ?? const SizedBox.shrink(),
    );
  }
}
