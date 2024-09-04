import 'package:flutter/material.dart';
import 'package:scrawler/helpers/constants.dart';

class ScrawlOutlinedIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  const ScrawlOutlinedIconButton(
      {super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(icon),
      ),
    );
  }
}
