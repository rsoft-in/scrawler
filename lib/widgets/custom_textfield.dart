import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:bnotes/helpers/globals.dart' as globals;

import '../common/constants.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField(
      {Key? key,
      required this.controller,
      this.icon,
      required this.hint,
      this.inputType,
      this.obscureText,
      this.isPassword})
      : super(key: key);
  final TextEditingController controller;
  final Icon? icon;
  final String hint;
  final TextInputType? inputType;
  final bool? obscureText;
  final bool? isPassword;

  @override
  State<StatefulWidget> createState() {
    return _CustomTextFieldState();
  }
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = false;

  @override
  void initState() {
    showPassword = widget.obscureText ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: darkModeOn ? kSecondaryDark : Colors.grey.withOpacity(0.1),
      ),
      child: Row(
        children: [
          widget.icon ?? Container(),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              keyboardType: widget.inputType,
              controller: widget.controller,
              obscureText: showPassword,
              decoration: InputDecoration.collapsed(
                hintText: widget.hint,
              ),
            ),
          ),
          Visibility(
            visible: widget.isPassword ?? false,
            child: InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              child:
                  showPassword ? Icon(LineIcons.eye) : Icon(LineIcons.eyeSlash),
            ),
          ),
        ],
      ),
    );
  }
}
