import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:bnotes/mobile/pages/mobile_note_editor.dart';
import 'package:bnotes/widgets/scrawl_appbar.dart';
import 'package:bnotes/widgets/scrawl_icon_button_outlined.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaru_icons/yaru_icons.dart';

import '../../helpers/constants.dart';
import '../../models/notes.dart';

class MobileNoteReader extends StatefulWidget {
  final Notes note;
  const MobileNoteReader({Key? key, required this.note}) : super(key: key);

  @override
  State<MobileNoteReader> createState() => _MobileNoteReaderState();
}

class _MobileNoteReaderState extends State<MobileNoteReader> {
  late ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  bool darkModeOn = false;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (globals.themeMode == ThemeMode.system &&
            brightness == Brightness.dark));

    return Scaffold(
      backgroundColor: darkModeOn ? kDarkPrimary : kLightPrimary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Container(
            alignment: Alignment.centerLeft,
            child: ScrawlAppBar(
              title: widget.note.noteTitle,
              onPressed: () => Navigator.pop(context, true),
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          controller: _scrollViewController,
          child: MarkdownBody(
              selectable: true,
              softLineBreak: true,
              onTapLink: (text, href, title) => _launchUrl(href),
              styleSheet: MarkdownStyleSheet(
                  blockquote: const TextStyle(color: Colors.black),
                  blockquoteDecoration: const BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      left: BorderSide(color: kPrimaryColor, width: 3),
                    ),
                  ),
                  code: const TextStyle(backgroundColor: Colors.transparent),
                  codeblockAlign: WrapAlignment.spaceAround,
                  codeblockDecoration: BoxDecoration(
                      color: darkModeOn ? Colors.white10 : Colors.black12),
                  checkbox: TextStyle(
                      color: darkModeOn ? kLightPrimary : kDarkPrimary)),
              data: widget.note.noteText),
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        height: _showAppbar ? 80.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: BottomAppBar(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              itemExtent: 80,
              scrollDirection: Axis.horizontal,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(YaruIcons.pen),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(YaruIcons.trash),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(YaruIcons.colors),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(YaruIcons.tag),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
