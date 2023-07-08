import 'package:bnotes/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class ScrawlOutlinedIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  const ScrawlOutlinedIconButton(
      {Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));

    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: darkModeOn ? kDarkPrimary : kLightPrimary,
          border: Border.all(
              color: darkModeOn ? kDarkStroke : kLightStroke, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(7),
        child: Icon(icon),
      ),
    );
  }
}
