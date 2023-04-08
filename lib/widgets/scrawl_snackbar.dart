import 'package:flutter/material.dart';

class ScrawlSnackBar {
  static dynamic show(BuildContext context, String content,
      {Duration duration = const Duration(seconds: 4)}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    return SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(15.0)),
            child: Text(
              content,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
    );
  }
}
