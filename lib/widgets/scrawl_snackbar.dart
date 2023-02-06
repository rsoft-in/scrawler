import 'package:flutter/material.dart';

class ScrawlSnackBar {
  static dynamic show(String content) {
    return SnackBar(
      // elevation: 0,
      // backgroundColor: Colors.transparent,
      content: Text(
        content,
        // style: TextStyle(color: Colors.black),
      ),
      duration: Duration(seconds: 2),
    );
  }
}
