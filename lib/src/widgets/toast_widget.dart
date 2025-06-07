import 'package:flutter/material.dart';

import '../helpers/constants.dart';

class ScrawlToast extends StatelessWidget {
  final String message;
  const ScrawlToast(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: kGlobalOuterPadding,
        decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(kBorderRadius)),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ));
  }
}
