import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0.00');

  /// Formats a double value to currency string with commas
  static String formatCurrency(double amount) {
    return _formatter.format(amount);
  }

  /// Formats a double value to currency string without decimal places if it's a whole number
  static String formatCurrencyCompact(double amount) {
    if (amount == amount.toInt()) {
      return NumberFormat('#,##0').format(amount);
    }
    return _formatter.format(amount);
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters except decimal point
    String cleanedText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Ensure only one decimal point
    List<String> parts = cleanedText.split('.');
    if (parts.length > 2) {
      cleanedText = '${parts[0]}.${parts.sublist(1).join('')}';
    }

    // Limit to 2 decimal places
    if (parts.length == 2 && parts[1].length > 2) {
      cleanedText = '${parts[0]}.${parts[1].substring(0, 2)}';
    }

    // Parse and format with commas
    double? value = double.tryParse(cleanedText);
    if (value == null) return oldValue;

    String formattedText;
    if (cleanedText.contains('.')) {
      // If user is typing decimal places, preserve the format
      List<String> splitValue = cleanedText.split('.');
      String integerPart =
          NumberFormat('#,##0').format(int.parse(splitValue[0]));
      formattedText =
          splitValue.length > 1 ? '$integerPart.${splitValue[1]}' : integerPart;
    } else {
      formattedText = NumberFormat('#,##0').format(value.toInt());
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
