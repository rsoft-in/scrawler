import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:flutter/material.dart';

class ScrawlFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const ScrawlFilledButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return FilledButton(
      style: FilledButton.styleFrom(
        foregroundColor: darkModeOn ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        // padding: EdgeInsets.symmetric(
        //     vertical: UniversalPlatform.isDesktopOrWeb ? 15 : 10,
        //     horizontal: 20),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
