import 'package:bnotes/widgets/scrawl_button_filled.dart';
import 'package:bnotes/widgets/scrawl_button_outlined.dart';
import 'package:flutter/material.dart';

import '../helpers/language.dart';

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
    // return AlertDialog(
    //   contentPadding: const EdgeInsets.all(50.0),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(50),
    //   ),
    //   content: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: [
    //       if (widget.content != null)
    //         Text(
    //           widget.content!,
    //           style: const TextStyle(fontSize: 22),
    //         ),
    //       kVSpace,
    //       kVSpace,
    //       ElevatedButton(
    //         onPressed: () => widget.onAcceptPressed(),
    //         style: ElevatedButton.styleFrom(
    //           backgroundColor: kAlertColor,
    //           // padding: kButtonPadding,
    //           textStyle: const TextStyle(
    //             fontFamily: 'Raleway',
    //             fontSize: 16.0,
    //           ),
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(kButtonBorderRadius),
    //           ),
    //         ),
    //         child: Text(Language.get('yes')),
    //       ),
    //       kVSpace,
    //       OutlinedButton(
    //         onPressed: () => Navigator.pop(context),
    //         child: Text(Language.get('no')),
    //       ),
    //     ],
    //   ),
    // );
    return AlertDialog(
      title: Text(widget.content!),
      actions: [
        ScrawlFilledButton(
          onPressed: () => widget.onAcceptPressed(),
          label: Language.get('yes'),
        ),
        ScrawlOutlinedButton(
          onPressed: () => Navigator.pop(context),
          label: Language.get('no'),
        ),
      ],
    );
  }
}
