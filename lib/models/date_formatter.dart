import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDateFormatter {
  static String format(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (dateTime == null) return '';

    DateTime localDateTime = dateTime.toLocal();

    String roughTimeString =
        DateFormat.Hm(Get.locale.languageCode).format(dateTime);

    if (isSameDay(localDateTime, now)) {
      return 'Today, hour'.trParams({"hour": "$roughTimeString"});
    }

    DateTime tomorrow = now.add(Duration(days: 1));

    if (isSameDay(localDateTime, tomorrow)) {
      return 'Tomorrow, hour'.trParams({"hour": "$roughTimeString"});
    }

    return '${DateFormat.yMd(Get.locale.languageCode).add_jm().format(dateTime)}';
  }
}
