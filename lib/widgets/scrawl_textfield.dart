import 'package:bnotes/common/constants.dart';
import 'package:flutter/material.dart';

class ScrawlTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final bool? obscure;
  final bool? isOTP;
  const ScrawlTextField(
      {Key? key, this.controller, this.hint, this.obscure, this.isOTP})
      : super(key: key);

  @override
  State<ScrawlTextField> createState() => _ScrawlTextFieldState();
}

class _ScrawlTextFieldState extends State<ScrawlTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        obscureText: widget.obscure ?? false,
        controller: widget.controller,
        textAlign: (widget.isOTP ?? false) ? TextAlign.center : TextAlign.left,
        style: TextStyle(
          fontSize: (widget.isOTP ?? false) ? 18.0 : 14.0,
          fontWeight:
              (widget.isOTP ?? false) ? FontWeight.bold : FontWeight.normal,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          prefixIconColor: kPrimaryColor,
          suffixIconColor: kPrimaryColor,
        ),
      ),
    );
  }
}
