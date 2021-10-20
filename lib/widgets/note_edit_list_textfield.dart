import 'package:flutter/material.dart';

class NoteEditListTextField extends StatefulWidget {
  final bool checkValue;
  final TextEditingController controller;
  final Function onSubmit;

  const NoteEditListTextField({Key? key, required this.checkValue, required this.controller, required this.onSubmit})
      : super(key: key);

  @override
  _NoteEditListTextFieldState createState() => _NoteEditListTextFieldState();
}

class _NoteEditListTextFieldState extends State<NoteEditListTextField> {
  bool _checkValue = false;

  @override
  void initState() {
    super.initState();
    _checkValue = widget.checkValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Checkbox(
              value: _checkValue,
              onChanged: (value) => setState(() {
                    _checkValue = value ?? false;
                  })),
          Expanded(
            child: TextField(
              decoration: InputDecoration.collapsed(hintText: ''),
              controller: widget.controller,
              onSubmitted: (value) => widget.onSubmit(),
            ),
          ),
        ],
      ),
    );
  }
}
