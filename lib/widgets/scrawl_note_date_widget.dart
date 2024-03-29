import 'package:flutter/material.dart';

class NoteDateWidget extends StatelessWidget {
  final String text;
  const NoteDateWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }
}
