import 'package:intl/intl.dart';

String toShortDate(DateTime dateTime) {
  return DateFormat('dd MMM, y').format(dateTime);
}

String toLongDate(DateTime dateTime) {
  return DateFormat('dd MMMM y, hh:mm a').format(dateTime);
}
