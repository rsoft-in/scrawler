import 'package:flutter/material.dart';
import 'package:scrawler/src/helpers/constants.dart';

class RSBadge extends StatelessWidget {
  final String text;
  const RSBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      decoration: BoxDecoration(
        color: kPrimaryColor.withAlpha(100),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: TextStyle(fontSize: 12)),
    );
  }
}
