// import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:scrawler/helpers/constants.dart';
import 'package:universal_platform/universal_platform.dart';

class WindowControls extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final showMaxButton;
  const WindowControls({super.key, this.showMaxButton = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: UniversalPlatform.isMacOS
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(15),
          child: Container(
              padding: const EdgeInsets.all(8),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: const Icon(
                Icons.minimize_outlined,
                size: 14,
              )),
          // onTap: () => appWindow.minimize(),
        ),
        if (showMaxButton) kHSpace,
        if (showMaxButton)
          InkWell(
            borderRadius: BorderRadius.circular(15),
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: const Icon(
                  Icons.square_outlined,
                  size: 14,
                )),
            // onTap: () => appWindow.maximizeOrRestore(),
          ),
        kHSpace,
        InkWell(
          borderRadius: BorderRadius.circular(15),
          child: Container(
              padding: const EdgeInsets.all(8),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: const Icon(
                Icons.close_outlined,
                size: 14,
              )),
          // onTap: () => appWindow.close(),
        ),
      ],
    );
  }
}
