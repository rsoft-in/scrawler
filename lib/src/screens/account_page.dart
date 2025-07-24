import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:scrawler/src/screens/about_page.dart';
import 'package:scrawler/src/screens/appearance_page.dart';

import '../helpers/globals.dart' as globals;

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List menu = [
    {
      'title': 'appearance'.tr(),
      'page': AppearancePage(),
      'icon': Symbols.dark_mode
    },
    {'title': 'about'.tr(), 'page': AboutPage(), 'icon': Symbols.info},
  ];
  @override
  Widget build(BuildContext context) {
    return FScaffold(
        header: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: FHeader(
            title: Text(globals.user.userName),
          ),
        ),
        childPad: false,
        child: SingleChildScrollView(
          child: FTileGroup(
            children: menu
                .map((mnu) => FTile(
                      prefix: Icon(mnu['icon']),
                      title: Text(mnu['title']),
                      suffix: Icon(FIcons.chevronRight),
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => mnu['page'],
                          ),
                        );
                      },
                    ))
                .toList(),
          ),
        ));

    // return Scaffold(
    //   body: CustomScrollView(
    //     slivers: [
    //       SliverAppBar.medium(
    //         title: Row(
    //           mainAxisSize: MainAxisSize.min,
    //           spacing: 16.0,
    //           children: [
    //             CircleAvatar(
    //               child: Icon(Symbols.person),
    //             ),
    //             Text(globals.user.userName),
    //           ],
    //         ),
    //         floating: true,
    //         snap: true,
    //       ),
    //       SliverList(
    //         delegate: SliverChildBuilderDelegate(
    //           (context, index) {
    //             return Material(
    //               type: MaterialType.card,
    //               child: ListTile(
    //                 leading: CircleAvatar(
    //                     backgroundColor: Theme.of(context)
    //                         .colorScheme
    //                         .surfaceContainerHighest,
    //                     foregroundColor:
    //                         Theme.of(context).colorScheme.onSurface,
    //                     child: Icon(menu[index]['icon'])),
    //                 title: Text(menu[index]['title']),
    //                 onTap: () {
    //                   Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => menu[index]['page'],
    //                     ),
    //                   );
    //                 },
    //               ),
    //             );
    //           },
    //           childCount: menu.length,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
