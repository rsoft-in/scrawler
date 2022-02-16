import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class AppBarBackButton extends StatefulWidget {
  final Function? onTap;
  const AppBarBackButton({Key? key, this.onTap}) : super(key: key);

  @override
  _AppBarBackButtonState createState() => _AppBarBackButtonState();
}

class _AppBarBackButtonState extends State<AppBarBackButton> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Container(
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
          if (widget.onTap == null)
            Navigator.pop(context);
          else
            widget.onTap!();
        },
        child: Icon(
          Iconsax.arrow_left_2,
          size: 15,
        ),
      ),
    );
  }
}
