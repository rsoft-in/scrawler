import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hint,
    required this.inputType,
    required this.obscureText,
  }) : super(key: key);
  final TextEditingController controller;
  final Icon icon;
  final String hint;
  final TextInputType inputType;
  final bool obscureText;

  @override
  State<StatefulWidget> createState() {
    return _CustomTextFieldState();
  }
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: darkModeOn ? kSecondaryDark : Colors.grey.withOpacity(0.1),
      ),
      child: Row(
        children: [
          widget.icon,
          SizedBox(width: 10,),
          Expanded(
            child: TextField(
              keyboardType: widget.inputType,
              controller: widget.controller,
              obscureText: widget.obscureText,
              decoration: InputDecoration.collapsed(
                hintText: widget.hint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
