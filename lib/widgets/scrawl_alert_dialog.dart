import 'package:flutter/material.dart';
import 'package:scrawler/helpers/constants.dart';

class ScrawlConfirmDialog extends StatefulWidget {
  final VoidCallback onAcceptPressed;
  final String title;
  final String? content;

  const ScrawlConfirmDialog(
      {super.key,
      this.content,
      required this.onAcceptPressed,
      required this.title});

  @override
  State<ScrawlConfirmDialog> createState() => _ScrawlConfirmDialogState();
}

class _ScrawlConfirmDialogState extends State<ScrawlConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: kGlobalOuterPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (widget.content!.isNotEmpty)
              Text(
                widget.content!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: FilledButton(
                onPressed: () => widget.onAcceptPressed(),
                // style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Yes'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
