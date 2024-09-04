import 'package:flutter/material.dart';
import 'package:scrawler/helpers/constants.dart';

class ScrawlCircularProgressIndicator extends StatelessWidget {
  const ScrawlCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: kPrimaryColor,
      strokeWidth: 2,
    );
  }
}
