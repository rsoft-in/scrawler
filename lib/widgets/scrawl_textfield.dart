import 'package:bnotes/helpers/constants.dart';
import 'package:bnotes/helpers/string_values.dart';
import 'package:flutter/material.dart';

class ScrawlTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final bool? obscure;
  final bool? isOTP;
  final bool? validate;
  const ScrawlTextField(
      {Key? key,
      this.controller,
      this.hint,
      this.obscure,
      this.isOTP,
      this.validate})
      : super(key: key);

  @override
  State<ScrawlTextField> createState() => _ScrawlTextFieldState();
}

class _ScrawlTextFieldState extends State<ScrawlTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
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
          border: const OutlineInputBorder(
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
        validator: ((widget.validate ?? false)
            ? (value) {
                if (value == null || value.isEmpty) {
                  return kLabels['please_enter_text']!;
                }
                return null;
              }
            : null),
      ),
    );
  }
}
