import 'package:flutter/material.dart';
import 'package:scrawler/helpers/constants.dart';

class ScrawlAddButton extends StatelessWidget {
  final VoidCallback onTap;
  const ScrawlAddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            border: Border.all(
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(kBorderRadius)),
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
