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

    // Clean up old signatures after 30 seconds
    Timer(const Duration(seconds: 30), () {
      _recentSubmissions.remove(signature);
    });

    _queueController.add(List.from(_queue));
    debugPrint('Added sale to queue with ID: $id, signature: $signature');
    return id;
  }

  String _createRequestSignature(CreateSaleRequestModel request) {
    // Create a unique signature based on sale content and timestamp (rounded to second)
    final timestamp =
        DateTime.now().millisecondsSinceEpoch ~/ 1000; // Round to second
    final itemsSignature =
        request.saleItems.map((item) => '${item.id}_${item.name}').join('|');
    return '${request.totalAmount}_${request.paymentMethod}_${itemsSignature}_$timestamp';
  }

  void _startProcessing() {
    _processTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _processNext();
    });
  }

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
      final createdSale =
          await _salesRepository.createSale(pendingSale.saleRequest);
      _queue.removeAt(processingIndex);
      _processedSaleController.add(createdSale);
    } catch (e) {
      // Mark with error but don't remove - will retry
      _queue[processingIndex] = _queue[processingIndex].copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }

    _queueController.add(List.from(_queue));
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
}

final salesQueueServiceProvider = Provider<SalesQueueService>((ref) {
  final service = SalesQueueService(SalesRepository());
  ref.onDispose(() => service.dispose());
  return service;
});
