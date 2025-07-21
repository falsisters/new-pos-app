import 'dart:convert';
import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiptStorageService {
  static const String _recentReceiptsKey = 'recent_receipts';
  static const int _maxStoredReceipts = 10; // Keep last 10 receipts
  static const Duration _storageRetention =
      Duration(hours: 24); // Keep for 24 hours

  Future<void> saveReceiptForReprint(SaleModel sale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingData = prefs.getString(_recentReceiptsKey);

      List<Map<String, dynamic>> receipts = [];
      if (existingData != null) {
        final List<dynamic> decoded = jsonDecode(existingData);
        receipts = decoded.cast<Map<String, dynamic>>();
      }

      // Add current receipt with timestamp
      final receiptData = {
        'sale': sale.toJson(),
        'savedAt': DateTime.now().toIso8601String(),
        'id': sale.id,
      };

      // Remove any existing receipt with same ID
      receipts.removeWhere((receipt) => receipt['id'] == sale.id);

      // Add to beginning
      receipts.insert(0, receiptData);

      // Clean up old receipts
      _cleanupOldReceipts(receipts);

      // Keep only the latest receipts
      if (receipts.length > _maxStoredReceipts) {
        receipts = receipts.take(_maxStoredReceipts).toList();
      }

      await prefs.setString(_recentReceiptsKey, jsonEncode(receipts));
      print('Receipt ${sale.id} saved for reprint');
    } catch (e) {
      print('Error saving receipt for reprint: $e');
    }
  }

  Future<SaleModel?> getReceiptForReprint(String saleId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingData = prefs.getString(_recentReceiptsKey);

      if (existingData == null) return null;

      final List<dynamic> decoded = jsonDecode(existingData);
      final receipts = decoded.cast<Map<String, dynamic>>();

      // Clean up old receipts first
      _cleanupOldReceipts(receipts);

      // Find the receipt
      final receiptData = receipts.firstWhere(
        (receipt) => receipt['id'] == saleId,
        orElse: () => <String, dynamic>{},
      );

      if (receiptData.isEmpty) return null;

      final saleData = receiptData['sale'] as Map<String, dynamic>;
      return SaleModel.fromJson(saleData);
    } catch (e) {
      print('Error getting receipt for reprint: $e');
      return null;
    }
  }

  Future<List<SaleModel>> getRecentReceipts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingData = prefs.getString(_recentReceiptsKey);

      if (existingData == null) return [];

      final List<dynamic> decoded = jsonDecode(existingData);
      final receipts = decoded.cast<Map<String, dynamic>>();

      // Clean up old receipts first
      _cleanupOldReceipts(receipts);

      // Convert to SaleModel list
      final List<SaleModel> sales = [];
      for (final receiptData in receipts) {
        try {
          final saleData = receiptData['sale'] as Map<String, dynamic>;
          sales.add(SaleModel.fromJson(saleData));
        } catch (e) {
          print('Error parsing stored receipt: $e');
        }
      }

      return sales;
    } catch (e) {
      print('Error getting recent receipts: $e');
      return [];
    }
  }

  void _cleanupOldReceipts(List<Map<String, dynamic>> receipts) {
    final cutoffTime = DateTime.now().subtract(_storageRetention);

    receipts.removeWhere((receipt) {
      try {
        final savedAtString = receipt['savedAt'] as String;
        final savedAt = DateTime.parse(savedAtString);
        return savedAt.isBefore(cutoffTime);
      } catch (e) {
        print('Error parsing receipt timestamp: $e');
        return true; // Remove invalid receipts
      }
    });
  }

  Future<void> clearAllReceipts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_recentReceiptsKey);
      print('All stored receipts cleared');
    } catch (e) {
      print('Error clearing receipts: $e');
    }
  }
}

final receiptStorageServiceProvider = Provider<ReceiptStorageService>((ref) {
  return ReceiptStorageService();
});
