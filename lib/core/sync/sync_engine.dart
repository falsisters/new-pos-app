import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:falsisters_pos_android/core/database/database.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/core/sync/sync_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SyncEngine {
  final AppDatabase _db;
  final DioClient _dio;
  final Ref _ref;
  Timer? _periodicTimer;

  SyncEngine(this._db, this._dio, this._ref);

  SyncStateNotifier get _syncState => _ref.read(syncStateProvider.notifier);

  Future<void> start() async {
    _periodicTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      syncAll();
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

  Future<void> _processEntry(dynamic entry) async {
    await (_db.update(_db.outboxEntries)
          ..where((tbl) => tbl.id.equals(entry.id)))
        .write(OutboxEntriesCompanion(
      status: const Value('syncing'),
    ));

    try {
      final response = await _dio.instance.request(
        entry.endpoint as String,
        data: entry.payload as String,
        options: Options(
          method: entry.method as String,
          headers: {
            'Idempotency-Key': entry.idempotencyKey as String,
            'X-Client-Cuid': entry.clientCuid as String,
          },
        ),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 409) {
        await (_db.update(_db.outboxEntries)
              ..where((tbl) => tbl.id.equals(entry.id)))
            .write(OutboxEntriesCompanion(
          status: const Value('synced'),
          syncedAt: Value(DateTime.now()),
        ));
      } else {
        await _markEntryFailed(
            entry.id, 'Unexpected status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        await _markEntryFailed(entry.id, e.toString());
      } else {
        final attempts = (entry.syncAttempts as int? ?? 0) + 1;
        if (attempts >= 5) {
          await _markEntryFailed(
              entry.id, 'Max retries exceeded: ${e.toString()}');
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

  void dispose() {
    _periodicTimer?.cancel();
  }
}

final syncEngineProvider = Provider<SyncEngine>((ref) {
  throw UnimplementedError(
      'SyncEngine must be initialized with a database instance');
});
