import 'package:easy_localization/easy_localization.dart';

bool isEmail(String? email) {
  if (email!.isEmpty) return true;
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._]+@[a-zA-Z0-9\-]+\.[a-zA-Z]+")
      .hasMatch(email);
}

String getInitials(String text) {
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

String formatDateTime(String dateTime) {
  var formatter = DateFormat('MMM dd, yyyy');
  var formatter2 = DateFormat('hh:mm a');
  DateTime dt = DateTime.parse(dateTime);
  int mins = DateTime.now().difference(dt).inMinutes;
  int hours = DateTime.now().difference(dt).inHours;
  int days = DateTime.now().difference(dt).inDays;
  if (mins < 5 && hours == 0 && days == 0) {
    return 'now';
  } else if (mins > 5 && hours == 0 && days == 0) {
    return 'minutes_ago'.plural(mins, namedArgs: {'count': '$mins'});
  } else if (hours >= 1 && hours < 9 && days == 0) {
    return 'hours_ago'.plural(hours, namedArgs: {'count': '$hours'});
  } else if (hours >= 9 && dt.day == DateTime.now().day) {
    return formatter2.format(dt);
  } else if (days > 0 && days <= 7) {
    return 'days_ago'.plural(days, namedArgs: {'count': '$days'});
  } else {
    return formatter.format(dt);
  }
}

String readableDate(String dateTime) {
  if (dateTime.isEmpty) return '';
  DateTime now = DateTime.now();
  DateTime date = DateTime.parse(dateTime);
  var days = now.difference(date).inDays;

  if (days == 0) {
    return 'today';
  } else if (days == 1) {
    return 'yesterday';
  } else if (days > 1 && days < 30) {
    return '$days days ago';
  } else {
    var mon = (days / 30).ceil();
    return '${mon}m ago';
  }
}

String stripNoteOfMD(String markDown) {
  return markDown.replaceAll(RegExp(r'[^A-Za-z0-9\s]+'), '');
}

String markDownToHtml(String markDown) {
  var html = markDown;
  html = html.replaceAll('\n', '<br>');
  return html;
}

bool isCheckedListItem(String listItem) {
  return listItem.contains("~");
}

String stripTags(String listItem) {
  String item = listItem;
  item = item.replaceAll('~', '');
  item = item.replaceAll('[CHECKBOX]\n', '');
  return item;
}

String getDateString() {
  var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  DateTime dt = DateTime.now();
  return formatter.format(dt);
}

enum AppLockState { set, confirm }

enum ThemeModeState { light, dark, system }

enum SupportState {
  unknown,
  supported,
  unsupported,
}

enum ScreenSize { small, medium, large }
