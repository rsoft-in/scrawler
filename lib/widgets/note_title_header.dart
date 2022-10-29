import 'package:flutter/material.dart';

class NoteTitleWidget extends StatefulWidget {
  final String text;
  const NoteTitleWidget({Key? key, required this.text}) : super(key: key);

  @override
  State<NoteTitleWidget> createState() => _NoteTitleWidgetState();
}

class _NoteTitleWidgetState extends State<NoteTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: SelectableText(
        widget.text,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
