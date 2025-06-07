import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class RSAlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final String acceptText;
  final String rejectText;
  final VoidCallback onAcceptAction;
  const RSAlertDialog(
      {super.key,
      this.title,
      this.content,
      required this.acceptText,
      required this.rejectText,
      required this.onAcceptAction});

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isIOS
        ? CupertinoAlertDialog(
            title: title,
            content: content,
            actions: [
              CupertinoDialogAction(
                onPressed: onAcceptAction,
                child: Text(acceptText),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(rejectText),
              ),
            ],
          )
        : AlertDialog(
            title: title,
            content: content,
            actions: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.tonal(
                    onPressed: onAcceptAction,
                    child: Text(acceptText),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(rejectText),
                  ),
                ],
              ),
            ],
          );
  }
}
