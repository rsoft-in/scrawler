import 'package:flutter/material.dart';

import '../helpers/constants.dart';

class ScrawlAlertButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  const ScrawlAlertButton(
      {Key? key, required this.onPressed, required this.label})
      : super(key: key);

  @override
  State<ScrawlAlertButton> createState() => _ScrawlAlertButtonState();
}

class _ScrawlAlertButtonState extends State<ScrawlAlertButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kAlertColor,
        padding: kButtonPadding,
        textStyle: const TextStyle(
          fontFamily: 'Raleway',
          fontSize: 16.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButtonBorderRadius),
        ),
      ),
      child: Text(widget.label),
    );
  }
}
