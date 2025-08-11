import 'dart:async';
import 'dart:math';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/pending_sale.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';
import 'package:falsisters_pos_android/features/sales/data/repository/sales_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesQueueService {
  final SalesRepository _salesRepository;
  final List<PendingSale> _queue = [];
  final StreamController<List<PendingSale>> _queueController =
      StreamController.broadcast();
  final StreamController<SaleModel> _processedSaleController =
      StreamController.broadcast();
  Timer? _processTimer;
  final Set<String> _recentSubmissions =
      {}; // Track recent submissions to prevent duplicates

  SalesQueueService(this._salesRepository) {
    _startProcessing();
  }

  Stream<List<PendingSale>> get queueStream => _queueController.stream;
  Stream<SaleModel> get processedSaleStream => _processedSaleController.stream;
  List<PendingSale> get currentQueue => List.unmodifiable(_queue);

  Future<void> _processNext() async {
    if (_queue.isEmpty) return;

    final pendingSale = _queue.first;
    if (pendingSale.isProcessing) return;

    // Mark as processing
    final processingIndex =
        _queue.indexWhere((sale) => sale.id == pendingSale.id);
    if (processingIndex == -1) return;

    _queue[processingIndex] = pendingSale.copyWith(isProcessing: true);
    _queueController.add(List.from(_queue));

    try {
      debugPrint('Processing sale with ID: ${pendingSale.id}');
      final createdSale =
          await _salesRepository.createSale(pendingSale.saleRequest);

      debugPrint(
          'Sale ${pendingSale.id} processed successfully, removing from queue');

      // Remove the successfully processed sale from queue
      _queue.removeWhere((sale) => sale.id == pendingSale.id);

      // Emit the processed sale
      _processedSaleController.add(createdSale);

      debugPrint('Queue now has ${_queue.length} pending sales');
    } catch (e) {
      debugPrint('Error processing sale ${pendingSale.id}: $e');

      // Check if this is a retriable error
      final isRetriable = _isRetriableError(e);

      if (isRetriable) {
        // Mark with error but keep in queue for retry
        final updatedSale = pendingSale.copyWith(
          isProcessing: false,
          error: e.toString(),
        );

        final existingIndex =
            _queue.indexWhere((sale) => sale.id == pendingSale.id);
        if (existingIndex != -1) {
          _queue[existingIndex] = updatedSale;
        }

        debugPrint('Sale ${pendingSale.id} marked for retry: ${e.toString()}');
      } else {
        // Non-retriable error - remove from queue
        _queue.removeWhere((sale) => sale.id == pendingSale.id);
        debugPrint(
            'Sale ${pendingSale.id} removed due to non-retriable error: ${e.toString()}');
      }
    }

    _queueController.add(List.from(_queue));
  }

  bool _isRetriableError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Network related errors that should be retried
    if (errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('network') ||
        errorString.contains('socket') ||
        errorString.contains('failed host lookup') ||
        errorString.contains('connection refused') ||
        errorString.contains('connection reset') ||
        errorString.contains('no internet') ||
        errorString.contains('server error') ||
        errorString.contains('internal server error') ||
        errorString.contains('service unavailable') ||
        errorString.contains('bad gateway') ||
        errorString.contains('gateway timeout')) {
      return true;
    }

    // HTTP status codes that should be retried (5xx server errors)
    if (errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503') ||
        errorString.contains('504')) {
      return true;
    }

    // Validation errors and client errors should not be retried
    if (errorString.contains('validation') ||
        errorString.contains('bad request') ||
        errorString.contains('unauthorized') ||
        errorString.contains('forbidden') ||
        errorString.contains('not found') ||
        errorString.contains('conflict') ||
        errorString.contains('400') ||
        errorString.contains('401') ||
        errorString.contains('403') ||
        errorString.contains('404') ||
        errorString.contains('409') ||
        errorString.contains('422')) {
      return false;
    }

    // Default to retry for unknown errors
    return true;
  }

  String _createRequestSignature(CreateSaleRequestModel request) {
    // Create a more specific signature to better detect duplicates
    final itemsSignature = request.saleItems
        .map((item) =>
            '${item.id}_${item.name}_${item.perKiloPrice?.quantity ?? item.sackPrice?.quantity ?? 0}')
        .join('|');

    // Use a longer time window (5 seconds) for duplicate detection
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 5000;

    return '${request.totalAmount}_${request.paymentMethod}_${itemsSignature}_$timestamp';
  }

  String addToQueue(CreateSaleRequestModel saleRequest) {
    // Create a signature for duplicate detection
    final signature = _createRequestSignature(saleRequest);

    if (_recentSubmissions.contains(signature)) {
      debugPrint('Duplicate sale request detected, skipping: $signature');
      return _queue.isNotEmpty ? _queue.last.id : 'duplicate';
    }

    final id = _generateId();
    final pendingSale = PendingSale(
      id: id,
      saleRequest: saleRequest,
      timestamp: DateTime.now(),
    );

    _queue.add(pendingSale);
    _recentSubmissions.add(signature);

    // Clean up old signatures after 60 seconds (increased from 30)
    Timer(const Duration(seconds: 60), () {
      _recentSubmissions.remove(signature);
    });

    _queueController.add(List.from(_queue));
    debugPrint(
        'Added sale to queue with ID: $id, signature: $signature. Queue size: ${_queue.length}');
    return id;
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }

  void dispose() {
    _processTimer?.cancel();
    _queueController.close();
    _processedSaleController.close();
  }

  void _startProcessing() {
    _processTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _processNext();
    });
  }

  // Add method to manually remove a sale from queue (for debugging)
  void removeSaleFromQueue(String saleId) {
    _queue.removeWhere((sale) => sale.id == saleId);
    _queueController.add(List.from(_queue));
    debugPrint(
        'Manually removed sale $saleId from queue. Queue size: ${_queue.length}');
  }

  // Add method to clear all failed sales
  void clearFailedSales() {
    _queue.removeWhere((sale) => sale.error != null);
    _queueController.add(List.from(_queue));
    debugPrint('Cleared failed sales from queue. Queue size: ${_queue.length}');
  }

  // Add method to retry failed sales
  void retryFailedSales() {
    for (int i = 0; i < _queue.length; i++) {
      if (_queue[i].error != null) {
        _queue[i] = _queue[i].copyWith(error: null, isProcessing: false);
      }
    }
    _queueController.add(List.from(_queue));
    debugPrint('Reset failed sales for retry. Queue size: ${_queue.length}');
  }
}

final salesQueueServiceProvider = Provider<SalesQueueService>((ref) {
  final service = SalesQueueService(SalesRepository());
  ref.onDispose(() => service.dispose());
  return service;
});
