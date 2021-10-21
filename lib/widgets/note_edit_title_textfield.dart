import 'package:flutter/material.dart';

class NoteEditTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? onSubmitFocusNode;
  final String? hint;
  final bool? isContentField;
  const NoteEditTextField(
      {Key? key,
      required this.controller,
      this.focusNode,
      this.onSubmitFocusNode,
      this.hint,
      this.isContentField})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this.controller,
      focusNode: this.focusNode,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: this.isContentField ?? false
          ? TextInputType.multiline
          : TextInputType.text,
      onSubmitted: this.isContentField ?? false
          ? null
          : (value) => this.onSubmitFocusNode?.requestFocus(),
      maxLines: null,
      decoration: InputDecoration.collapsed(
          hintText: this.hint ?? 'Hint',
          hintStyle: TextStyle(
              fontWeight: this.isContentField ?? false
                  ? FontWeight.normal
                  : FontWeight.bold)),
    );
  }
}
