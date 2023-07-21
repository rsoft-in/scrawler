import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

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

    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            vertical: UniversalPlatform.isDesktopOrWeb ? 15 : 10,
            horizontal: 20),
        decoration: BoxDecoration(
            color: darkModeOn ? kDarkPrimary : kLightPrimary,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
                color: darkModeOn ? kDarkStroke : kLightStroke, width: 2)),
        child: Text(label),
      ),
    );
  }
}
