import 'package:bnotes/common/constants.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class SAppBar extends StatefulWidget {
  final String title;
  final List<Widget>? action;
  final bool? centerTitle;
  final Color? backgroundColor;
  final double? elevation;
  final Function? onTap;
  const SAppBar(
      {Key? key,
      required this.title,
      this.action,
      this.centerTitle,
      this.backgroundColor,
      this.elevation,
      this.onTap})
      : super(key: key);

  @override
  _SAppBarState createState() => _SAppBarState();
}

class _SAppBarState extends State<SAppBar> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return AppBar(
      leading: Container(
        margin: const EdgeInsets.all(8.0),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10),
        //   color: darkModeOn
        //       ? FlexColor.jungleDarkPrimary
        //       : FlexColor.jungleLightPrimary,
        // ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (widget.onTap == null)
              Navigator.pop(context);
            else
              widget.onTap!();
          },
          child: Icon(
            Iconsax.arrow_left_2,
            size: 15,
            // color: Colors.white,
          ),
        ),
      ),
      centerTitle: widget.centerTitle ?? true,
      backgroundColor: widget.backgroundColor,
      elevation: widget.elevation,
      title: Text(widget.title),
      actions: widget.action,
    );
  }
}
