import 'package:flutter/material.dart';

class ScrawlButtonPrimary extends StatefulWidget {
  final String label;
  final Function onPressed;
  const ScrawlButtonPrimary(
      {Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  State<ScrawlButtonPrimary> createState() => _ScrawlButtonPrimaryState();
}

class _ScrawlButtonPrimaryState extends State<ScrawlButtonPrimary> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(widget.label),
      onPressed: () => widget.onPressed(),
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.black,
        textStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Raleway',
          fontSize: 18.0,
        ),
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
