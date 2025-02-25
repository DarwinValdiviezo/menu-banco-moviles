import 'package:intl/intl.dart';

String formatDate(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return DateFormat('dd/MM/yyyy').format(parsedDate);
}

String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(locale: 'en_US', symbol: "\$");
  return formatter.format(amount);
}
