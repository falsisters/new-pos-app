import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters except decimal point
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Handle multiple decimal points
    List<String> parts = digitsOnly.split('.');
    if (parts.length > 2) {
      digitsOnly = '${parts[0]}.${parts.sublist(1).join('')}';
    }

    // Limit to 2 decimal places
    if (parts.length == 2 && parts[1].length > 2) {
      digitsOnly = '${parts[0]}.${parts[1].substring(0, 2)}';
    }

    if (digitsOnly.isEmpty) {
      return const TextEditingValue();
    }

    // Parse the number
    double? value = double.tryParse(digitsOnly);
    if (value == null) {
      return oldValue;
    }

    // Format with commas
    String formatted;
    if (digitsOnly.contains('.')) {
      List<String> splitValue = digitsOnly.split('.');
      String integerPart = splitValue[0];
      String decimalPart = splitValue.length > 1 ? splitValue[1] : '';

      // Add commas to integer part
      if (integerPart.isNotEmpty) {
        int intValue = int.tryParse(integerPart) ?? 0;
        String formattedInteger = intValue.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
        formatted = decimalPart.isNotEmpty
            ? '$formattedInteger.$decimalPart'
            : formattedInteger;
      } else {
        formatted = '.$decimalPart';
      }
    } else {
      int intValue = int.tryParse(digitsOnly) ?? 0;
      formatted = intValue.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
