import 'package:bnotes/helpers/constants.dart';
import 'package:flutter/material.dart';

class ScrawlConfirmDialog extends StatefulWidget {
  final VoidCallback onAcceptPressed;
  final String content;

  const ScrawlConfirmDialog(
      {super.key, required this.content, required this.onAcceptPressed});

  @override
  State<ScrawlConfirmDialog> createState() => _ScrawlConfirmDialogState();
}

class _ScrawlConfirmDialogState extends State<ScrawlConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: kGlobalOuterPadding,
        child: Text(
          widget.content,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => widget.onAcceptPressed(),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),
      ],
    );
  }
}
