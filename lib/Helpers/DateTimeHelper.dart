import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

String getDateTime({required String datetime}) {
  DateTime parsedDatetime = DateTime.parse(datetime);
  DateTime currentDatetime = DateTime.now();
  if ((currentDatetime.year - parsedDatetime.year) != 0) {
    if ((currentDatetime.year - parsedDatetime.year) == 1) {
      return "${currentDatetime.year - parsedDatetime.year} year";
    } else {
      return "${currentDatetime.year - parsedDatetime.year} years";
    }
  } else if ((currentDatetime.month - parsedDatetime.month) != 0) {
    if ((currentDatetime.month - parsedDatetime.month) == 1) {
      return "${currentDatetime.month - parsedDatetime.month} month";
    } else {
      return "${currentDatetime.month - parsedDatetime.month} months";
    }
  } else if ((currentDatetime.day - parsedDatetime.day) != 0) {
    if ((currentDatetime.day - parsedDatetime.day) == 1) {
      return "${currentDatetime.day - parsedDatetime.day} day";
    } else {
      return "${currentDatetime.day - parsedDatetime.day} days";
    }
  } else if ((currentDatetime.hour - parsedDatetime.hour) != 0) {
    if ((currentDatetime.hour - parsedDatetime.hour) == 1) {
      return "${currentDatetime.hour - parsedDatetime.hour} hour";
    } else {
      return "${currentDatetime.hour - parsedDatetime.hour} hours";
    }
  } else if ((currentDatetime.minute - parsedDatetime.minute) != 0) {
    if ((currentDatetime.minute - parsedDatetime.minute) == 1) {
      return "${currentDatetime.minute - parsedDatetime.minute} minute";
    } else {
      return "${currentDatetime.minute - parsedDatetime.minute} minutes";
    }
  } else {
    return "${currentDatetime.second - parsedDatetime.second} seconds";
  }
}

String formatDate(DateTime date) => new DateFormat("dd/MM/yyyy").format(date);
String formatTime(DateTime date) => new DateFormat("h:mm a").format(date);
String formatDuration(Duration d) => d.toString().split('.').first.padLeft(8, "0");
String getDateTimeChat({required DateTime datetime}) {
  DateTime currentDatetime = DateTime.now();
  return datetime.isAfter(currentDatetime.subtract(Duration(days: 1)))
      ? formatTime(datetime)
      : datetime.isAfter(currentDatetime.subtract(Duration(days: 2)))
      ? "yesterday"
      : formatDate(datetime);
  // Duration duration = currentDatetime.difference(datetime);
  // if (duration.inDays == 0) {
  //   return formatTime(datetime);
  // } else if (duration.inDays == 1) {
  //   return "Yesterday";
  // } else {
  //   return formatDate(datetime);
  // }
}

// String getDateTimeInChat({required DateTime datetime}) {
//   DateTime currentDatetime = DateTime.now();
//   // Duration duration = currentDatetime.difference(datetime);
//   return datetime.isAfter(currentDatetime.subtract(Duration(days: 1)))
//       ? "Today"
//       : datetime.isAfter(currentDatetime.subtract(Duration(days: 2)))
//           ? "Yesterday"
//           : formatDate(datetime);
//   // if (duration.inDays == 0) {
//   //   return "Today";
//   // } else if (duration.inDays == 1) {
//   //   return "Yesterday";
//   // } else {
//   //   return formatDate(datetime);
//   // }
// }

String getDateTimeInChat({required DateTime datetime}) {
  print("getDateTimeInChat ${datetime.toString()}");
  tz.TZDateTime checkedTime = tz.TZDateTime.parse(tz.local, datetime.toString());
  tz.TZDateTime currentTime = tz.TZDateTime.now(tz.local);
  print("getDateTimeInChat");

  if ((currentTime.year == checkedTime.year) && (currentTime.month == checkedTime.month) && (currentTime.day == checkedTime.day)) {
    return "today";
  } else if ((currentTime.year == checkedTime.year) && (currentTime.month == checkedTime.month)) {
    if ((currentTime.day - checkedTime.day) == 1) {
      return "yesterday";
    } else if ((currentTime.day - checkedTime.day) == -1) {
      return "tomorrow";
    } else {
      return DateFormat.yMMMd().format(tz.TZDateTime.parse(tz.local, datetime.toString()));
    }
  }
  return DateFormat.yMMMd().format(tz.TZDateTime.parse(tz.local, datetime.toString()));
}

DateTime getDateTimeSinceEpoch({required String datetime}) {
  return DateTime.fromMillisecondsSinceEpoch(int.parse(datetime));
}
