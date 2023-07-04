import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:flutter/material.dart';

class ScrawlNavRailItem extends StatefulWidget {
  final int index;
  final String tooltip;
  final int selectedIndex;
  final IconData icon;
  final VoidCallback onTap;
  const ScrawlNavRailItem(
      {Key? key,
      required this.index,
      required this.tooltip,
      required this.selectedIndex,
      required this.icon,
      required this.onTap})
      : super(key: key);

  @override
  State<ScrawlNavRailItem> createState() => _ScrawlNavRailItemState();
}

class _ScrawlNavRailItemState extends State<ScrawlNavRailItem> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Tooltip(
      message: widget.tooltip,
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
              color: widget.selectedIndex == widget.index
                  ? darkModeOn
                      ? kDarkSelected
                      : kLightSelected
                  : null,
              borderRadius: BorderRadius.circular(5)),
          child: Icon(
            widget.icon,
            size: 22.0,
            color: widget.selectedIndex == widget.index
                ? darkModeOn
                    ? kDarkPrimary
                    : Colors.black
                : darkModeOn
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      ),
    );
  }
}
