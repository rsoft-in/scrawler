import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/widgets/scrawl_icon_button_outlined.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class ScrawlAppBar extends StatefulWidget {
  final Widget middle;
  final Function onPressed;

  final Widget? trailing;
  const ScrawlAppBar(
      {Key? key, required this.middle, required this.onPressed, this.trailing})
      : super(key: key);

  @override
  State<ScrawlAppBar> createState() => _ScrawlAppBarState();
}

class _ScrawlAppBarState extends State<ScrawlAppBar> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ScrawlOutlinedIconButton(
                icon: Icons.arrow_back_ios_new,
                onPressed: () => widget.onPressed()),
            kHSpace,
            Expanded(child: widget.middle),
            kHSpace,
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
      ),
    );
  }
}
