import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class RSButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  const RSButton({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isIOS || UniversalPlatform.isMacOS
        ? CupertinoButton.filled(onPressed: onPressed, child: child)
        : FilledButton(onPressed: onPressed, child: child);
  }
}
