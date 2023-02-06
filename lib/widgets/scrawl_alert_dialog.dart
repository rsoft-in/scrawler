import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../common/language.dart';

class ScrawlConfirmDialog extends StatefulWidget {
  final VoidCallback onAcceptPressed;
  final String? content;

  const ScrawlConfirmDialog(
      {Key? key, this.content, required this.onAcceptPressed})
      : super(key: key);

  @override
  State<ScrawlConfirmDialog> createState() => _ScrawlConfirmDialogState();
}

class _ScrawlConfirmDialogState extends State<ScrawlConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(50.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.content != null)
            Text(
              widget.content!,
              style: TextStyle(fontSize: 22),
            ),
          kVSpace,
          kVSpace,
          ElevatedButton(
            onPressed: () => widget.onAcceptPressed(),
            child: Text(Language.get('yes')),
            style: ElevatedButton.styleFrom(
              backgroundColor: kAlertColor,
              padding: kButtonPadding,
              textStyle: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 16.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kButtonBorderRadius),
              ),
            ),
          ),
          kVSpace,
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Language.get('no')),
          ),
        ],
      ),
    );
  }
}
