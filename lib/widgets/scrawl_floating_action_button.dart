import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:flutter/material.dart';

class ScrawlFloatingActionButton extends StatelessWidget {
  const ScrawlFloatingActionButton(
      {Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  final VoidCallback? onPressed;
  final IconData icon;

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
          color: darkModeOn ? kLightPrimary : kDarkPrimary,
          border: Border.all(
              color: darkModeOn ? kLightStroke : kDarkStroke, width: 2),
          borderRadius: BorderRadius.circular(kBorderRadiusSmall),
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(icon, color: darkModeOn ? Colors.black : Colors.white),
      ),
    );
  }
}
