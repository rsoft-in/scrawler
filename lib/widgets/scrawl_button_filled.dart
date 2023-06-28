import 'package:flutter/material.dart';

class ScrawlFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const ScrawlFilledButton(
      {Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: const EdgeInsets.all(20.0)),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
