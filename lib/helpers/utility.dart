import 'package:intl/intl.dart';

class Utility {
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
