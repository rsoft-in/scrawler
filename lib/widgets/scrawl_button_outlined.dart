import 'package:bnotes/helpers/constants.dart';
import 'package:flutter/material.dart';

class ScrawlOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const ScrawlOutlinedButton(
      {Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          backgroundColor: kLightPrimary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: const EdgeInsets.all(20.0)),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
