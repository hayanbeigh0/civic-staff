import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDate;
  }

  static String formatDateTime(String timestamp) {
    var dateTime = DateTime.parse(timestamp);
    var formatter = DateFormat('hh:mm a - dd/MM/yy');
    return formatter.format(dateTime);
  }

  static String formatTimeStamp(String timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    return formattedDate;
  }
}
