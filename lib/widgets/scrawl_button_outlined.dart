import 'package:bnotes/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class ScrawlOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const ScrawlOutlinedButton(
      {Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          backgroundColor: darkModeOn ? kDarkPrimary : kLightPrimary,
          foregroundColor: darkModeOn ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(
              color: darkModeOn ? kDarkStroke : kLightStroke,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(20.0)),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
