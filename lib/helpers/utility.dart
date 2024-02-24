import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:universal_platform/universal_platform.dart';

class Utility {
  static void showSnackbar(BuildContext context, String message) {
    if (UniversalPlatform.isIOS) {
      CupertinoAlertDialog alert = CupertinoAlertDialog(
        content: Text(message),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );

      showCupertinoDialog(
        context: context,
        builder: (context) {
          return alert;
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        width: 320,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  static String getInitials(String text) {
    var aText = text.trim().split(" ");
    String initials = "";
    for (var i = 0; i < aText.length; i++) {
      if (i > 1) break;
      try {
        initials += aText[i].substring(0, 1);
      } on Exception {
        initials += "00";
      }
    }
    return initials;
  }

  static String formatDateTime(String dateTime) {
    var formatter = DateFormat('MMM dd, yyyy');
    var formatter2 = DateFormat('hh:mm a');
    DateTime dt = DateTime.parse(dateTime);
    if (dt.day == DateTime.now().day) {
      return formatter2.format(dt);
    } else {
      return formatter.format(dt);
    }
  }

  static String markDownToHtml(String markDown) {
    var html = markDown;
    html = html.replaceAll('\n', '<br>');
    return html;
  }

  static bool isCheckedListItem(String listItem) {
    return listItem.contains("~");
  }

  static String stripTags(String listItem) {
    String item = listItem;
    item = item.replaceAll('~', '');
    item = item.replaceAll('[CHECKBOX]\n', '');
    return item;
  }

  static String getDateString() {
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime dt = DateTime.now();
    return formatter.format(dt);
  }
}

enum AppLockState { set, confirm }

enum ThemeModeState { light, dark, system }

enum SupportState {
  unknown,
  supported,
  unsupported,
}

enum ScreenSize { small, medium, large }
