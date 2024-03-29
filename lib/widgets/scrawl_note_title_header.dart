import 'package:flutter/material.dart';

class NoteTitleWidget extends StatelessWidget {
  final String text;
  const NoteTitleWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: SelectableText(
        text,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
