import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class RSTextButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  const RSTextButton({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isIOS
        ? CupertinoButton(onPressed: onPressed, child: child)
        : TextButton(onPressed: onPressed, child: child);
  }
}
