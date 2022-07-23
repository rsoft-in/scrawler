import 'package:bnotes/common/constants.dart';
import 'package:flutter/material.dart';

class ScrawlTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final bool? obscure;
  const ScrawlTextField({Key? key, this.controller, this.hint, this.obscure})
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
