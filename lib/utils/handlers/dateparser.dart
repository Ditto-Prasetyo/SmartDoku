import 'package:intl/intl.dart';

String parseDateTimeFormat(DateTime date) {
  return DateFormat('dd MMMM yyyy', 'id_ID').format(date)
      + "\n"
      + DateFormat('HH:mm', 'id_ID').format(date);
}

String parseDateFormat(DateTime date) {
  final formatted = DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  return formatted;
}

String parseTimeFormat(DateTime time) {
  final formatted = DateFormat('HH:mm', 'id_ID').format(time);
  return formatted;
}