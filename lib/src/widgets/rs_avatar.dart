import 'package:flutter/material.dart';

class RSTextAvatar extends StatelessWidget {
  final Color color;
  final String text;
  const RSTextAvatar({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: color,
      ),
      child: Align(alignment: Alignment.center, child: Text(text)),
    );
  }
}
