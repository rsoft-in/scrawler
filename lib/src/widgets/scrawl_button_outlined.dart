import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class ScrawlOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const ScrawlOutlinedButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            vertical: UniversalPlatform.isDesktopOrWeb ? 15 : 10,
            horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(width: 2)),
        child: Text(label),
      ),
    );
  }
}
