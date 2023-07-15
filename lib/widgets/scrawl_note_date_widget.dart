import 'package:flutter/material.dart';

class NoteDateWidget extends StatelessWidget {
  final String text;
  const NoteDateWidget({Key? key, required this.text}) : super(key: key);

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
