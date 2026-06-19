import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:falsisters_pos_android/core/database/database.dart';
import 'package:falsisters_pos_android/core/database/providers/database_provider.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/core/sync/connectivity_service.dart';
import 'package:falsisters_pos_android/core/sync/sync_state.dart';
import 'package:falsisters_pos_android/features/inventory/data/local/inventory_local_repository.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/local/kahon_local_repository.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';
import 'package:falsisters_pos_android/features/products/data/local/products_local_repository.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SyncEngine {
  final AppDatabase _db;
  final DioClient _dio;
  final Ref _ref;
  Timer? _periodicTimer;
  StreamSubscription<bool>? _connectivitySubscription;

  SyncEngine(this._db, this._dio, this._ref);

  SyncStateNotifier get _syncState => _ref.read(syncStateProvider.notifier);

  Future<void> start() async {
    _periodicTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      syncAll();
    });

    final connectivityService = ConnectivityService();
    _connectivitySubscription =
        connectivityService.connectivityStream.listen((isConnected) {
      if (isConnected) {
        syncAll();
      }
    });
  }

  Future<void> syncAll() async {
    final syncState = _ref.read(syncStateProvider);
    if (syncState.isSyncing) return;

    _syncState.setSyncing(true);

    try {
      final pendingEntries = await (_db.select(_db.outboxEntries)
            ..where((tbl) => tbl.status.equals('pending'))
            ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
          .get();

      _syncState.setPendingCount(pendingEntries.length);

      for (final entry in pendingEntries) {
        try {
          await _processEntry(entry);
        } catch (e) {
          await _markEntryFailed(entry.id, e.toString());
        }
      }

      _syncState.setSynced();
    } catch (e) {
      _syncState.setError(e.toString());
    }
  }

  Future<void> syncFeature(String feature) async {
    final pendingEntries = await (_db.select(_db.outboxEntries)
          ..where((tbl) => tbl.status.equals('pending') & tbl.feature.equals(feature))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .get();

    for (final entry in pendingEntries) {
      try {
        await _processEntry(entry);
      } catch (e) {
        await _markEntryFailed(entry.id, e.toString());
      }
    }
  }

  Future<void> pullAndMerge(String entityType, String apiEndpoint) async {
    try {
      final response = await _dio.instance.get(apiEndpoint);
      final data = response.data;

      if (data == null) return;

      switch (entityType) {
        case 'sales':
          final List<Map<String, dynamic>> serverRows =
              (data is List) ? data.cast<Map<String, dynamic>>() : [];
          await _mergeSalesFromServer(serverRows);
          break;
        case 'products':
          if (data is List) {
            final products = data
                .map((j) => Product.fromJson(j as Map<String, dynamic>))
                .toList();
            final localRepo = ProductsLocalRepository(_db);
            await localRepo.clearAndUpsert(products);
          }
          break;
        case 'kahon':
          if (data is Map<String, dynamic>) {
            final sheet = SheetModel.fromJson(data);
            final localRepo = KahonLocalRepository(_db);
            await localRepo.upsertSheetFromServer(sheet);
          }
          break;
        case 'inventory':
          if (data is Map<String, dynamic>) {
            final sheet = InventorySheetModel.fromJson(data);
            final localRepo = InventoryLocalRepository(_db);
            await localRepo.upsertSheetFromServer(sheet);
          }
          break;
        default:
          break;
      }
    } catch (e) {
      _syncState.setError('pullAndMerge($entityType): $e');
    }
  }

  Future<void> _processEntry(OutboxEntry entry) async {
    await (_db.update(_db.outboxEntries)
          ..where((tbl) => tbl.id.equals(entry.id)))
        .write(OutboxEntriesCompanion(
      status: const Value('syncing'),
    ));

    try {
      final response = await _dio.instance.request(
        entry.endpoint,
        data: jsonDecode(entry.payload),
        options: Options(
          method: entry.method,
          extra: {
            '_outboxHeaders': {
              'Idempotency-Key': entry.idempotencyKey,
              'X-Client-Cuid': entry.clientCuid,
            },
          },
        ),
      );

      final statusCode = response.statusCode ?? 0;

      if (statusCode == 200 || statusCode == 201) {
        await _upsertLocalEntity(entry, response.data);
        await (_db.update(_db.outboxEntries)
              ..where((tbl) => tbl.id.equals(entry.id)))
            .write(OutboxEntriesCompanion(
          status: const Value('synced'),
          syncedAt: Value(DateTime.now()),
        ));
      } else if (statusCode == 409) {
        if (response.data != null) {
          await _upsertLocalEntity(entry, response.data);
        }
        await (_db.update(_db.outboxEntries)
              ..where((tbl) => tbl.id.equals(entry.id)))
            .write(OutboxEntriesCompanion(
          status: const Value('synced'),
          syncedAt: Value(DateTime.now()),
        ));
      } else {
        await _markEntryFailed(
            entry.id, 'Unexpected status: $statusCode');
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        await _markEntryFailed(entry.id, e.toString());
      } else {
        final attempts = entry.syncAttempts + 1;
        if (attempts >= 5) {
          await _markEntryFailed(
              entry.id, 'Max retries exceeded: $e');
        } else {
          await (_db.update(_db.outboxEntries)
                ..where((tbl) => tbl.id.equals(entry.id)))
              .write(OutboxEntriesCompanion(
            status: const Value('pending'),
            syncAttempts: Value(attempts),
            error: Value(e.toString()),
          ));
        }
      }
    }
  }

  Future<void> _upsertLocalEntity(OutboxEntry entry, dynamic responseData) async {
    if (responseData == null) return;

    try {
      switch (entry.feature) {
        case 'sales':
          await _upsertSaleFromResponse(entry, responseData);
          break;
        case 'kahon':
          await _upsertKahonFromResponse(entry, responseData);
          break;
        case 'inventory':
          await _upsertInventoryFromResponse(entry, responseData);
          break;
        default:
          break;
      }
    } catch (e) {
      _syncState.setError('_upsertLocalEntity(${entry.feature}): $e');
    }
  }

  Future<void> _upsertSaleFromResponse(
      OutboxEntry entry, dynamic responseData) async {
    final data = responseData is Map<String, dynamic>
        ? responseData
        : jsonDecode(responseData.toString()) as Map<String, dynamic>;

    final saleId = data['id'] as String?;
    if (saleId == null) return;

    if (entry.operation == 'create') {
      final existing = await (_db.select(_db.localSales)
            ..where((tbl) => tbl.id.equals(entry.clientCuid)))
          .getSingleOrNull();

      if (existing != null) {
        await _db.transaction(() async {
          await (_db.delete(_db.localSales)
                ..where((tbl) => tbl.id.equals(entry.clientCuid)))
              .go();
          await (_db.delete(_db.localSaleItems)
                ..where((tbl) => tbl.saleId.equals(entry.clientCuid)))
              .go();
        });
      }
    } else if (entry.operation == 'delete') {
      await _db.transaction(() async {
        await (_db.delete(_db.localSaleItems)
              ..where((tbl) => tbl.saleId.equals(saleId)))
            .go();
        await (_db.delete(_db.localSales)
              ..where((tbl) => tbl.id.equals(saleId)))
            .go();
      });
      return;
    }

    await _insertLocalSaleFromServer(data, saleId);
  }

  Future<void> _insertLocalSaleFromServer(
      Map<String, dynamic> data, String saleId) async {
    final saleItems = data['SaleItem'] as List<dynamic>? ?? [];

    final localSale = LocalSalesCompanion.insert(
      id: saleId,
      cashierId: data['cashierId']?.toString() ?? '',
      totalAmount: (data['totalAmount'] is num)
          ? (data['totalAmount'] as num).toDouble()
          : double.tryParse(data['totalAmount']?.toString() ?? '0') ?? 0,
      paymentMethod: data['paymentMethod']?.toString() ?? '',
      discount: data['discount'] != null
          ? Value((data['discount'] is num
              ? (data['discount'] as num).toDouble()
              : double.tryParse(data['discount'].toString())))
          : const Value.absent(),
      orderId: data['orderId'] != null ? Value(data['orderId'].toString()) : const Value.absent(),
      createdAt: data['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
      updatedAt: data['updatedAt']?.toString() ?? DateTime.now().toIso8601String(),
      synced: Value(true),
      localUpdatedAt: DateTime.now(),
    );

    await _db.into(_db.localSales).insertOnConflictUpdate(localSale);

    for (final item in saleItems) {
      final itemMap = item as Map<String, dynamic>;
      final product = itemMap['product'] as Map<String, dynamic>? ?? {};

      await _db.into(_db.localSaleItems).insertOnConflictUpdate(
        LocalSaleItemsCompanion.insert(
          id: itemMap['id']?.toString() ?? '',
          saleId: saleId,
          productId: itemMap['productId']?.toString() ?? product['id']?.toString() ?? '',
          productName: product['name']?.toString() ?? '',
          productPicture: product['picture'] != null ? Value(product['picture'].toString()) : const Value.absent(),
          quantity: (itemMap['quantity'] is num)
              ? (itemMap['quantity'] as num).toDouble()
              : double.tryParse(itemMap['quantity']?.toString() ?? '0') ?? 0,
          price: itemMap['price'] != null
              ? Value(itemMap['price'] is num
                  ? (itemMap['price'] as num).toDouble()
                  : double.tryParse(itemMap['price'].toString()))
              : const Value.absent(),
          discountedPrice: itemMap['discountedPrice'] != null
              ? Value(itemMap['discountedPrice'] is num
                  ? (itemMap['discountedPrice'] as num).toDouble()
                  : double.tryParse(itemMap['discountedPrice'].toString()))
              : const Value.absent(),
          sackPriceId: itemMap['sackPriceId'] != null ? Value(itemMap['sackPriceId'].toString()) : const Value.absent(),
          sackType: itemMap['sackType'] != null ? Value(itemMap['sackType'].toString()) : const Value.absent(),
          perKiloPriceId: itemMap['perKiloPriceId'] != null ? Value(itemMap['perKiloPriceId'].toString()) : const Value.absent(),
          isGantang: Value(itemMap['isGantang'] == true),
          isSpecialPrice: Value(itemMap['isSpecialPrice'] == true),
          isDiscounted: Value(itemMap['isDiscounted'] == true),
          sackPricePrice: itemMap['SackPrice']?['price'] != null
              ? Value(itemMap['SackPrice']['price'] is num
                  ? (itemMap['SackPrice']['price'] as num).toDouble()
                  : double.tryParse(itemMap['SackPrice']['price'].toString()))
              : const Value.absent(),
          perKiloPricePrice: itemMap['perKiloPrice']?['price'] != null
              ? Value(itemMap['perKiloPrice']['price'] is num
                  ? (itemMap['perKiloPrice']['price'] as num).toDouble()
                  : double.tryParse(itemMap['perKiloPrice']['price'].toString()))
              : const Value.absent(),
          synced: Value(true),
        ),
      );
    }
  }

  Future<void> _mergeSalesFromServer(List<Map<String, dynamic>> serverRows) async {
    final localIds = serverRows.map((r) => r['id'] as String).toSet();

    for (final serverSale in serverRows) {
      final saleId = serverSale['id'] as String;
      final localSale = await (_db.select(_db.localSales)
            ..where((tbl) => tbl.id.equals(saleId)))
          .getSingleOrNull();

      if (localSale != null) {
        if (localSale.synced) {
          await _db.transaction(() async {
            await (_db.delete(_db.localSaleItems)
                  ..where((tbl) => tbl.saleId.equals(saleId)))
                .go();
            await (_db.delete(_db.localSales)
                  ..where((tbl) => tbl.id.equals(saleId)))
                .go();
          });
          await _insertLocalSaleFromServer(serverSale, saleId);
        }
      } else {
        await _insertLocalSaleFromServer(serverSale, saleId);
      }
    }

    final allLocalSales = await _db.select(_db.localSales).get();
    for (final localSale in allLocalSales) {
      if (localSale.synced && !localIds.contains(localSale.id)) {
        await _db.transaction(() async {
          await (_db.delete(_db.localSaleItems)
                ..where((tbl) => tbl.saleId.equals(localSale.id)))
              .go();
          await (_db.delete(_db.localSales)
                ..where((tbl) => tbl.id.equals(localSale.id)))
              .go();
        });
      }
    }
  }

  Future<void> _upsertKahonFromResponse(
      OutboxEntry entry, dynamic responseData) async {
    final dynamic data = responseData is Map || responseData is List
        ? responseData
        : jsonDecode(responseData.toString());

    if (entry.operation == 'delete') {
      if (entry.endpoint.contains('/cell/')) {
        final cellId = entry.clientCuid;
        await (_db.delete(_db.localCells)
              ..where((tbl) => tbl.id.equals(cellId)))
            .go();
        return;
      }
      if (entry.endpoint.contains('/row/')) {
        final rowId = entry.clientCuid;
        await (_db.delete(_db.localCells)
              ..where((tbl) => tbl.rowId.equals(rowId)))
            .go();
        await (_db.delete(_db.localRows)
              ..where((tbl) => tbl.id.equals(rowId)))
            .go();
        return;
      }
      return;
    }

    if (entry.operation == 'create') {
      if (entry.endpoint == '/sheet/cell') {
        final serverCellId = data['id'] as String?;
        if (serverCellId != null) {
          await (_db.update(_db.localCells)
                ..where((tbl) => tbl.id.equals(entry.clientCuid)))
              .write(LocalCellsCompanion(
            id: Value(serverCellId),
            synced: const Value(true),
            localUpdatedAt: Value(DateTime.now()),
          ));
        }
        return;
      }

      if (entry.endpoint == '/sheet/cells') {
        if (data is List) {
          final payload = jsonDecode(entry.payload) as List<dynamic>;
          for (var i = 0; i < data.length && i < payload.length; i++) {
            final serverCell = data[i] as Map<String, dynamic>;
            final serverCellId = serverCell['id'] as String?;
            if (serverCellId == null) continue;

            final payloadItem = payload[i] as Map<String, dynamic>;
            final rowId = payloadItem['rowId'] as String?;
            final columnIndex = payloadItem['columnIndex'] as int?;

            if (rowId != null && columnIndex != null) {
              final localCells = await (_db.select(_db.localCells)
                    ..where((tbl) =>
                        tbl.rowId.equals(rowId) &
                        tbl.columnIndex.equals(columnIndex) &
                        tbl.synced.equals(false)))
                  .get();

              for (final lc in localCells) {
                await (_db.update(_db.localCells)
                      ..where((tbl) => tbl.id.equals(lc.id)))
                  .write(LocalCellsCompanion(
                    id: Value(serverCellId),
                    synced: const Value(true),
                    localUpdatedAt: Value(DateTime.now()),
                  ));
              }
            }
          }
        }
        return;
      }

      if (entry.endpoint == '/sheet/calculation-row') {
        final serverRowId = data['id'] as String?;
        if (serverRowId != null) {
          await (_db.update(_db.localRows)
                ..where((tbl) => tbl.id.equals(entry.clientCuid)))
              .write(LocalRowsCompanion(
            id: Value(serverRowId),
            synced: const Value(true),
            updatedAt: Value(DateTime.now()),
          ));

          final serverCells = data['Cells'] as List<dynamic>? ?? [];
          final localCells = await (_db.select(_db.localCells)
                ..where((tbl) => tbl.rowId.equals(entry.clientCuid) & tbl.synced.equals(false)))
              .get();

          for (var i = 0; i < serverCells.length && i < localCells.length; i++) {
            final serverCell = serverCells[i] as Map<String, dynamic>;
            final serverCellId = serverCell['id'] as String?;
            if (serverCellId != null) {
              await (_db.update(_db.localCells)
                    ..where((tbl) => tbl.id.equals(localCells[i].id)))
                .write(LocalCellsCompanion(
                  id: Value(serverCellId),
                  synced: const Value(true),
                  localUpdatedAt: Value(DateTime.now()),
                ));
            }
          }
        }
        return;
      }
    }

    if (entry.operation == 'update') {
      if (entry.endpoint == '/sheet/cells' || entry.endpoint.contains('/cell')) {
        if (data is List) {
          for (final serverCell in data) {
            final cellId = serverCell['id'] as String?;
            if (cellId != null) {
              await (_db.update(_db.localCells)
                    ..where((tbl) => tbl.id.equals(cellId)))
                  .write(LocalCellsCompanion(
                synced: const Value(true),
                localUpdatedAt: Value(DateTime.now()),
              ));
            }
          }
        } else {
          final cellId = data['id'] as String?;
          if (cellId != null) {
            await (_db.update(_db.localCells)
                  ..where((tbl) => tbl.id.equals(cellId)))
                .write(LocalCellsCompanion(
              synced: const Value(true),
              localUpdatedAt: Value(DateTime.now()),
            ));
          }
        }
        return;
      }

      if (entry.endpoint.contains('/rows/positions') ||
          entry.endpoint.contains('/reorder')) {
        final localRepo = KahonLocalRepository(_db);
        await _db.transaction(() async {
          final payload = jsonDecode(entry.payload) as Map<String, dynamic>;
          final mappings = (payload['mappings'] ?? payload['rowMappings']) as List<dynamic>? ?? [];

          for (final mapping in mappings) {
            final m = mapping as Map<String, dynamic>;
            final rowId = m['rowId'] as String?;
            if (rowId != null) {
              await (_db.update(_db.localRows)
                    ..where((tbl) => tbl.id.equals(rowId)))
                  .write(LocalRowsCompanion(
                synced: const Value(true),
                updatedAt: Value(DateTime.now()),
              ));
            }
          }

          final formulaUpdates = payload['formulaUpdates'] as List<dynamic>? ?? [];
          for (final update in formulaUpdates) {
            final u = update as Map<String, dynamic>;
            final cellId = u['cellId'] as String?;
            if (cellId != null) {
              await (_db.update(_db.localCells)
                    ..where((tbl) => tbl.id.equals(cellId)))
                  .write(LocalCellsCompanion(
                synced: const Value(true),
                localUpdatedAt: Value(DateTime.now()),
              ));
            }
          }
        });
      }
    }
  }

  Future<void> _upsertInventoryFromResponse(
      OutboxEntry entry, dynamic responseData) async {
    final dynamic data = responseData is Map || responseData is List
        ? responseData
        : jsonDecode(responseData.toString());

    if (entry.operation == 'delete') {
      if (entry.endpoint.contains('/cell/')) {
        await (_db.delete(_db.localInventoryCells)
              ..where((tbl) => tbl.id.equals(entry.clientCuid)))
            .go();
        return;
      }
      if (entry.endpoint.contains('/row/')) {
        final rowId = entry.clientCuid;
        await (_db.delete(_db.localInventoryCells)
              ..where((tbl) => tbl.inventoryRowId.equals(rowId)))
            .go();
        await (_db.delete(_db.localInventoryRows)
              ..where((tbl) => tbl.id.equals(rowId)))
            .go();
        return;
      }
      return;
    }

    if (entry.operation == 'create') {
      if (entry.endpoint == '/inventory/cell') {
        final serverCellId = data['id'] as String?;
        if (serverCellId != null) {
          await (_db.update(_db.localInventoryCells)
                ..where((tbl) => tbl.id.equals(entry.clientCuid)))
              .write(LocalInventoryCellsCompanion(
            id: Value(serverCellId),
            synced: const Value(true),
            localUpdatedAt: Value(DateTime.now()),
          ));
        }
        return;
      }

      if (entry.endpoint == '/inventory/cells') {
        if (data is List) {
          final payload = jsonDecode(entry.payload) as List<dynamic>;
          for (var i = 0; i < data.length && i < payload.length; i++) {
            final serverCell = data[i] as Map<String, dynamic>;
            final serverCellId = serverCell['id'] as String?;
            if (serverCellId == null) continue;

            final payloadItem = payload[i] as Map<String, dynamic>;
            final rowId = payloadItem['rowId'] as String?;
            final columnIndex = payloadItem['columnIndex'] as int?;

            if (rowId != null && columnIndex != null) {
              final localCells = await (_db.select(_db.localInventoryCells)
                    ..where((tbl) =>
                        tbl.inventoryRowId.equals(rowId) &
                        tbl.columnIndex.equals(columnIndex) &
                        tbl.synced.equals(false)))
                  .get();

              for (final lc in localCells) {
                await (_db.update(_db.localInventoryCells)
                      ..where((tbl) => tbl.id.equals(lc.id)))
                  .write(LocalInventoryCellsCompanion(
                    id: Value(serverCellId),
                    synced: const Value(true),
                    localUpdatedAt: Value(DateTime.now()),
                  ));
              }
            }
          }
        }
        return;
      }

      if (entry.endpoint == '/inventory/calculation-row') {
        final serverRowId = data['id'] as String?;
        if (serverRowId != null) {
          await (_db.update(_db.localInventoryRows)
                ..where((tbl) => tbl.id.equals(entry.clientCuid)))
              .write(LocalInventoryRowsCompanion(
            id: Value(serverRowId),
            synced: const Value(true),
            updatedAt: Value(DateTime.now()),
          ));

          final serverCells = data['Cells'] as List<dynamic>? ?? [];
          final localCells = await (_db.select(_db.localInventoryCells)
                ..where((tbl) =>
                    tbl.inventoryRowId.equals(entry.clientCuid) &
                    tbl.synced.equals(false)))
              .get();

          for (var i = 0;
              i < serverCells.length && i < localCells.length;
              i++) {
            final serverCell = serverCells[i] as Map<String, dynamic>;
            final serverCellId = serverCell['id'] as String?;
            if (serverCellId != null) {
              await (_db.update(_db.localInventoryCells)
                    ..where((tbl) => tbl.id.equals(localCells[i].id)))
                .write(LocalInventoryCellsCompanion(
                  id: Value(serverCellId),
                  synced: const Value(true),
                  localUpdatedAt: Value(DateTime.now()),
                ));
            }
          }
        }
        return;
      }
    }

    if (entry.operation == 'update') {
      if (entry.endpoint == '/inventory/cells' ||
          entry.endpoint.contains('/cell')) {
        if (data is List) {
          for (final serverCell in data) {
            final cellId = serverCell['id'] as String?;
            if (cellId != null) {
              await (_db.update(_db.localInventoryCells)
                    ..where((tbl) => tbl.id.equals(cellId)))
                  .write(LocalInventoryCellsCompanion(
                synced: const Value(true),
                localUpdatedAt: Value(DateTime.now()),
              ));
            }
          }
        } else {
          final cellId = data['id'] as String?;
          if (cellId != null) {
            await (_db.update(_db.localInventoryCells)
                  ..where((tbl) => tbl.id.equals(cellId)))
                .write(LocalInventoryCellsCompanion(
              synced: const Value(true),
              localUpdatedAt: Value(DateTime.now()),
            ));
          }
        }
        return;
      }

      if (entry.endpoint.contains('/rows/positions') ||
          entry.endpoint.contains('/reorder')) {
        await _db.transaction(() async {
          final payload = jsonDecode(entry.payload) as Map<String, dynamic>;
          final mappings = (payload['mappings'] ?? payload['rowMappings'])
              as List<dynamic>? ??
              [];

          for (final mapping in mappings) {
            final m = mapping as Map<String, dynamic>;
            final rowId = m['rowId'] as String?;
            if (rowId != null) {
              await (_db.update(_db.localInventoryRows)
                    ..where((tbl) => tbl.id.equals(rowId)))
                  .write(LocalInventoryRowsCompanion(
                synced: const Value(true),
                updatedAt: Value(DateTime.now()),
              ));
            }
          }

          final formulaUpdates =
              payload['formulaUpdates'] as List<dynamic>? ?? [];
          for (final update in formulaUpdates) {
            final u = update as Map<String, dynamic>;
            final cellId = u['cellId'] as String?;
            if (cellId != null) {
              await (_db.update(_db.localInventoryCells)
                    ..where((tbl) => tbl.id.equals(cellId)))
                  .write(LocalInventoryCellsCompanion(
                synced: const Value(true),
                localUpdatedAt: Value(DateTime.now()),
              ));
            }
          }
        });
      }
    }
  }

  Future<void> retryEntry(String id) async {
    await (_db.update(_db.outboxEntries)
          ..where((tbl) => tbl.id.equals(id)))
        .write(OutboxEntriesCompanion(
      status: const Value('pending'),
      syncAttempts: const Value(0),
      error: const Value.absent(),
    ));
  }

  Future<void> _markEntryFailed(String id, String error) async {
    await (_db.update(_db.outboxEntries)
          ..where((tbl) => tbl.id.equals(id)))
        .write(OutboxEntriesCompanion(
      status: const Value('failed'),
      error: Value(error),
    ));
  }

  Future<int> pendingCount() async {
    final query = _db.selectOnly(_db.outboxEntries)
      ..addColumns([_db.outboxEntries.id.count()])
      ..where(_db.outboxEntries.status.equals('pending'));
    final row = await query.getSingle();
    return row.read(_db.outboxEntries.id.count())!;
  }

  Future<int> failedCount() async {
    final query = _db.selectOnly(_db.outboxEntries)
      ..addColumns([_db.outboxEntries.id.count()])
      ..where(_db.outboxEntries.status.equals('failed'));
    final row = await query.getSingle();
    return row.read(_db.outboxEntries.id.count())!;
  }

  Future<List<OutboxEntry>> failedEntries() async {
    return (_db.select(_db.outboxEntries)
          ..where((tbl) => tbl.status.equals('failed'))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  void dispose() {
    _periodicTimer?.cancel();
    _connectivitySubscription?.cancel();
  }
}

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final db = ref.watch(databaseProvider).requireValue;
  final dio = DioClient();
  return SyncEngine(db, dio, ref)..start();
});



