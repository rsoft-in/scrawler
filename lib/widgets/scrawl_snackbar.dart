import 'package:flutter/material.dart';
import '../helpers/globals.dart' as globals;

class ScrawlSnackBar {
  static dynamic show(BuildContext context, String content,
      {Duration duration = const Duration(seconds: 4)}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: darkModeOn ? Colors.white70 : Colors.black87,
                borderRadius: BorderRadius.circular(15.0)),
            child: Text(
              content,
              style: TextStyle(color: darkModeOn ? Colors.black : Colors.white),
            ),
          ),
        ],
      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
    );
  }
}
