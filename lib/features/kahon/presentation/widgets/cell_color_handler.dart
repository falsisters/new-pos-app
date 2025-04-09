import 'package:flutter/material.dart';

/// Handles cell color operations and provides a standard color palette
class CellColorHandler {
  // Map of color names to Color objects with good contrast with black text
  static final Map<String, Color> colorPalette = {
    'White': Colors.white,
    'Light Blue': Colors.lightBlue.shade100,
    'Light Green': Colors.lightGreen.shade100,
    'Light Yellow': Color(0xFFFFFACD), // Lemon chiffon
    'Light Pink': Colors.pink.shade100,
    'Light Purple': Colors.purple.shade100,
    'Light Cyan': Colors.cyan.shade100,
    'Light Orange': Colors.orange.shade100,
    'Grey': Colors.grey.shade200,
    'Light Amber': Colors.amber.shade100,
  };

  // Get a color from a string hex value
  static Color? getColorFromHex(String? hexString) {
    if (hexString == null || hexString.isEmpty) {
      return null;
    }

    try {
      String hex = hexString.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF' + hex;
      }
      return Color(int.parse('0x$hex'));
    } catch (e) {
      return null;
    }
  }

  // Convert a color to a hex string
  static String getHexFromColor(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }
}
