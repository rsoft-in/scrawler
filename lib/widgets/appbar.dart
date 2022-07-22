import 'package:bnotes/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

class CustomAppBar extends StatefulWidget {
  final String username;
  const CustomAppBar({Key? key, required this.username}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Container(
      // color: Colors.white,
      height: 100,
      padding: EdgeInsets.only(
        left: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: kPrimaryColor.withAlpha(100),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: darkModeOn ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                            children: [
                              TextSpan(text: 'Hey '),
                              TextSpan(
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                  ),
                                  text: widget.username)
                            ]),
                      ),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: darkModeOn ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                            children: [
                              TextSpan(text: 'Good '),
                              TextSpan(text: 'Morning')
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
            onTap: () {},
            child: Container(
              padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
              width: 80,
              decoration: BoxDecoration(
                color:
                    darkModeOn ? kSecondaryDark : kPrimaryColor.withAlpha(50),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25)),
              ),
              child: Icon(Icons.search, color: kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
