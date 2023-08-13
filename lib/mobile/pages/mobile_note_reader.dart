import 'package:bnotes/helpers/globals.dart' as globals;
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: AnimatedContainer(
            height: _showAppbar ? 56.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: AppBar(
              leading: GestureDetector(
                  onTap: () => Navigator.pop(context, true),
                  child: const Icon(YaruIcons.pan_start)),
              title: Text(widget.note.noteTitle),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: kPaddingLarge,
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
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
