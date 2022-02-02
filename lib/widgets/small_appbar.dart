import 'package:bnotes/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SAppBar extends StatefulWidget {
  final String title;
  final List<Widget>? action;
  final bool? centerTitle;
  final Color? backgroundColor;
  final double? elevation;
  const SAppBar(
      {Key? key,
      required this.title,
      this.action,
      this.centerTitle,
      this.backgroundColor,
      this.elevation})
      : super(key: key);

  @override
  _SAppBarState createState() => _SAppBarState();
}

class _SAppBarState extends State<SAppBar> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return AppBar(
      leading: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: darkModeOn
              ? Colors.grey.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Iconsax.arrow_left_2,
            size: 15,
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
