import 'package:bnotes/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class ScrawlFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const ScrawlFilledButton(
      {Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: darkModeOn ? kDarkSelected : Colors.black,
        foregroundColor: darkModeOn ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(
              color: darkModeOn ? kLightStroke : kDarkStroke, width: 2),
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
