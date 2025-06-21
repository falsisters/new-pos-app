import 'package:intl/intl.dart';

class BillCountFormatter {
  static final NumberFormat _currencyFormat = NumberFormat("#,##0.00", "en_US");
  static final NumberFormat _integerFormat = NumberFormat("#,##0", "en_US");

  static String formatCurrency(double value) {
    return _currencyFormat.format(value);
  }

  static String formatInteger(int value) {
    return _integerFormat.format(value);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  static String formatDateForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
