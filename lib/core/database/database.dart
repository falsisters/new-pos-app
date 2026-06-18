import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:falsisters_pos_android/core/database/converters/date_time_converter.dart';
import 'package:falsisters_pos_android/core/database/tables/local_entities.dart';
import 'package:falsisters_pos_android/core/database/tables/local_inventory_tables.dart';
import 'package:falsisters_pos_android/core/database/tables/local_kahon_tables.dart';
import 'package:falsisters_pos_android/core/database/tables/local_products_tables.dart';
import 'package:falsisters_pos_android/core/database/tables/local_sales_tables.dart';
import 'package:falsisters_pos_android/core/database/tables/outbox_entries.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    OutboxEntries,
    LocalEntities,
    LocalSales,
    LocalSaleItems,
    LocalProducts,
    LocalSackPrices,
    LocalPerKiloPrices,
    LocalKahons,
    LocalSheets,
    LocalRows,
    LocalCells,
    LocalKahonItems,
    LocalInventory,
    LocalInventorySheets,
    LocalInventoryRows,
    LocalInventoryCells,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal(super.e);

  static AppDatabase? _instance;

  static Future<AppDatabase> getInstance() async {
    if (_instance != null) return _instance!;

    final connection = await _openConnection();
    _instance = AppDatabase._internal(connection);
    return _instance!;
  }

  static Future<QueryExecutor> _openConnection() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'falsisters_offline.db'));
    return NativeDatabase.createInBackground(file);
  }

  @override
  int get schemaVersion => 1;
}
