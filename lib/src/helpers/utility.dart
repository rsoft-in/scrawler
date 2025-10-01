import 'package:easy_localization/easy_localization.dart';

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'email_empty'.tr();
  }
  final bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value);

  if (!emailValid) {
    return 'enter_valid_email'.tr();
  }
  return null;
}

String getInitials(String text) {
  // Split on whitespace, remove empty parts
  final words = text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
  String initials = "";
  for (var word in words) {
    // Find first alphanumeric character in this word
    final match = RegExp(r'[A-Za-z0-9]').firstMatch(word);
    if (match != null) {
      initials += match.group(0)!;
    }
    if (initials.length >= 2) break; // Stop at 2
  }
  return initials.toUpperCase(); // force uppercase
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
