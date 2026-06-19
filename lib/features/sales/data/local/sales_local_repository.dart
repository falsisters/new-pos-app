import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:falsisters_pos_android/core/database/database.dart';
import 'package:falsisters_pos_android/core/sync/idempotency_service.dart';
import 'package:falsisters_pos_android/features/products/data/models/per_kilo_price_model.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/products/data/models/sack_price_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_item.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';

class SalesLocalRepository {
  final AppDatabase _db;

  SalesLocalRepository(this._db);

  Future<SaleModel> createSale(CreateSaleRequestModel request) async {
    final saleCuid = IdempotencyService.generateCuid();
    final now = DateTime.now();
    final nowIso = now.toIso8601String();

    await _db.transaction(() async {
      final localSale = LocalSalesCompanion.insert(
        id: saleCuid,
        cashierId: request.cashierId ?? '',
        totalAmount: request.totalAmount.toDouble(),
        paymentMethod: request.paymentMethod.name,
        discount: const Value.absent(),
        orderId: request.orderId != null ? Value(request.orderId) : const Value.absent(),
        createdAt: nowIso,
        updatedAt: nowIso,
        synced: Value(false),
        localUpdatedAt: now,
      );

      await _db.into(_db.localSales).insert(localSale);

      for (final item in request.saleItems) {
        final itemCuid = IdempotencyService.generateCuid();
        await _db.into(_db.localSaleItems).insert(
          LocalSaleItemsCompanion.insert(
            id: itemCuid,
            saleId: saleCuid,
            productId: item.id,
            productName: item.name,
            productPicture: const Value.absent(),
            quantity: (item.perKiloPrice?.quantity ?? item.sackPrice?.quantity ?? Decimal.one).toDouble(),
            price: item.price != null ? Value(item.price!.toDouble()) : const Value.absent(),
            discountedPrice: item.discountedPrice != null ? Value(item.discountedPrice!.toDouble()) : const Value.absent(),
            sackPriceId: item.sackPrice?.id != null ? Value(item.sackPrice!.id) : const Value.absent(),
            sackType: item.sackPrice?.type != null ? Value(item.sackPrice!.type.name) : const Value.absent(),
            perKiloPriceId: item.perKiloPrice?.id != null ? Value(item.perKiloPrice!.id) : const Value.absent(),
            isGantang: Value(item.isGantang ?? false),
            isSpecialPrice: Value(item.isSpecialPrice ?? false),
            isDiscounted: Value(item.isDiscounted ?? false),
            sackPricePrice: item.sackPrice?.price != null ? Value(item.sackPrice!.price.toDouble()) : const Value.absent(),
            perKiloPricePrice: item.perKiloPrice?.price != null ? Value(item.perKiloPrice!.price.toDouble()) : const Value.absent(),
            synced: Value(false),
          ),
        );
      }

      final outboxEntry = OutboxEntriesCompanion.insert(
        id: IdempotencyService.generateCuid(),
        feature: 'sales',
        operation: 'create',
        endpoint: '/sale/create',
        method: 'POST',
        clientCuid: saleCuid,
        payload: jsonEncode(request.toJson()),
        idempotencyKey: IdempotencyService.generateIdempotencyKey(),
        createdAt: now,
      );

      await _db.into(_db.outboxEntries).insert(outboxEntry);
    });

    return _buildSaleModelFromLocal(
      id: saleCuid,
      cashierId: request.cashierId ?? '',
      totalAmount: request.totalAmount,
      paymentMethod: request.paymentMethod.name,
      orderId: request.orderId,
      createdAt: nowIso,
      updatedAt: nowIso,
      items: request.saleItems,
    );
  }

  Future<List<SaleModel>> getSales({DateTime? date}) async {
    final query = _db.select(_db.localSales)
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);

    final localSales = await query.get();

    final List<SaleModel> results = [];
    for (final ls in localSales) {
      final items = await (_db.select(_db.localSaleItems)
            ..where((tbl) => tbl.saleId.equals(ls.id)))
          .get();

      results.add(_buildSaleModelFromLocalRows(ls, items));
    }

    if (date != null) {
      final dateStr = date.toIso8601String().split('T')[0];
      results.removeWhere((s) => !s.createdAt.startsWith(dateStr));
    }

    return results;
  }

  Future<void> deleteSale(String id) async {
    final now = DateTime.now();

    await _db.transaction(() async {
      await (_db.update(_db.localSales)
            ..where((tbl) => tbl.id.equals(id)))
          .write(LocalSalesCompanion(
        synced: const Value(false),
        localUpdatedAt: Value(now),
      ));

      final outboxEntry = OutboxEntriesCompanion.insert(
        id: IdempotencyService.generateCuid(),
        feature: 'sales',
        operation: 'delete',
        endpoint: '/sale/$id',
        method: 'DELETE',
        clientCuid: id,
        payload: jsonEncode({}),
        idempotencyKey: IdempotencyService.generateIdempotencyKey(),
        createdAt: now,
      );

      await _db.into(_db.outboxEntries).insert(outboxEntry);
    });
  }

  Future<void> upsertFromServer(List<SaleModel> sales) async {
    for (final sale in sales) {
      final existing = await (_db.select(_db.localSales)
            ..where((tbl) => tbl.id.equals(sale.id)))
          .getSingleOrNull();

      if (existing != null) {
        if (!existing.synced) continue;

        await _db.transaction(() async {
          await (_db.delete(_db.localSaleItems)
                ..where((tbl) => tbl.saleId.equals(sale.id)))
              .go();
          await (_db.delete(_db.localSales)
                ..where((tbl) => tbl.id.equals(sale.id)))
              .go();

          await _insertSaleModel(sale);
        });
      } else {
        await _insertSaleModel(sale);
      }
    }
  }

  Future<void> _insertSaleModel(SaleModel sale) async {
    await _db.into(_db.localSales).insertOnConflictUpdate(
      LocalSalesCompanion.insert(
        id: sale.id,
        cashierId: sale.cashierId,
        totalAmount: sale.totalAmount.toDouble(),
        paymentMethod: sale.paymentMethod.name,
        discount: const Value.absent(),
        orderId: sale.metadata?['orderId'] != null ? Value(sale.metadata!['orderId'].toString()) : const Value.absent(),
        createdAt: sale.createdAt,
        updatedAt: sale.updatedAt,
        synced: Value(true),
        localUpdatedAt: DateTime.now(),
      ),
    );

    for (final item in sale.saleItems) {
      await _db.into(_db.localSaleItems).insertOnConflictUpdate(
        LocalSaleItemsCompanion.insert(
          id: item.id,
          saleId: sale.id,
          productId: item.productId,
          productName: item.product.name,
          productPicture: item.product.picture.isNotEmpty ? Value(item.product.picture) : const Value.absent(),
          quantity: item.quantity.toDouble(),
          price: item.price != null ? Value(item.price!.toDouble()) : const Value.absent(),
          discountedPrice: item.discountedPrice != null ? Value(item.discountedPrice!.toDouble()) : const Value.absent(),
          sackPriceId: item.sackPriceId != null ? Value(item.sackPriceId) : const Value.absent(),
          sackType: item.sackType?.name != null ? Value(item.sackType!.name) : const Value.absent(),
          perKiloPriceId: item.perKiloPriceId != null ? Value(item.perKiloPriceId) : const Value.absent(),
          isGantang: Value(item.isGantang),
          isSpecialPrice: Value(item.isSpecialPrice),
          isDiscounted: Value(item.isDiscounted),
          sackPricePrice: item.sackPrice?.price != null ? Value(item.sackPrice!.price.toDouble()) : const Value.absent(),
          perKiloPricePrice: item.perKiloPrice?.price != null ? Value(item.perKiloPrice!.price.toDouble()) : const Value.absent(),
          synced: Value(true),
        ),
      );
    }
  }

  SaleModel _buildSaleModelFromLocal({
    required String id,
    required String cashierId,
    required Decimal totalAmount,
    required String paymentMethod,
    String? orderId,
    required String createdAt,
    required String updatedAt,
    required List<dynamic> items,
  }) {
    final paymentMethodEnum = PaymentMethod.values.firstWhere(
      (e) => e.name == paymentMethod,
      orElse: () => PaymentMethod.CASH,
    );

    return SaleModel(
      id: id,
      cashierId: cashierId,
      totalAmount: totalAmount,
      paymentMethod: paymentMethodEnum,
      saleItems: _buildSaleItemsFromLocal(items),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  SaleModel _buildSaleModelFromLocalRows(LocalSale ls, List<LocalSaleItem> items) {
    final paymentMethodEnum = PaymentMethod.values.firstWhere(
      (e) => e.name == ls.paymentMethod,
      orElse: () => PaymentMethod.CASH,
    );

    return SaleModel(
      id: ls.id,
      cashierId: ls.cashierId,
      totalAmount: Decimal.parse(ls.totalAmount.toString()),
      paymentMethod: paymentMethodEnum,
      saleItems: _buildSaleItemsFromLocalRows(items),
      createdAt: ls.createdAt,
      updatedAt: ls.updatedAt,
    );
  }

  List<SaleItem> _buildSaleItemsFromLocal(List<dynamic> items) {
    if (items is List<ProductDto>) {
      return items.map((item) {
        return SaleItem(
          id: item.id,
          productId: item.id,
          product: Product(
            id: item.id,
            name: item.name,
            picture: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            userId: '',
            sackPrice: [],
          ),
          quantity: item.perKiloPrice?.quantity ?? item.sackPrice?.quantity ?? Decimal.one,
          price: item.price,
          discountedPrice: item.discountedPrice,
          sackPriceId: item.sackPrice?.id,
          sackType: item.sackPrice?.type,
          perKiloPriceId: item.perKiloPrice?.id,
          saleId: '',
          isGantang: item.isGantang ?? false,
          isSpecialPrice: item.isSpecialPrice ?? false,
          isDiscounted: item.isDiscounted ?? false,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        );
      }).toList();
    }
    return [];
  }

  List<SaleItem> _buildSaleItemsFromLocalRows(List<LocalSaleItem> items) {
    return items.map((item) {
      final sackPrice = item.sackPriceId != null
          ? SackPrice(
              id: item.sackPriceId!,
              price: Decimal.parse((item.sackPricePrice ?? 0).toString()),
              stock: Decimal.zero,
              type: _parseSackType(item.sackType) ?? SackType.FIFTY_KG,
              productId: item.productId,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            )
          : null;

      final perKiloPrice = item.perKiloPriceId != null
          ? PerKiloPrice(
              id: item.perKiloPriceId!,
              price: Decimal.parse((item.perKiloPricePrice ?? 0).toString()),
              stock: Decimal.zero,
              productId: item.productId,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            )
          : null;

      return SaleItem(
        id: item.id,
        productId: item.productId,
        product: Product(
          id: item.productId,
          name: item.productName,
          picture: item.productPicture,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          userId: '',
          sackPrice: [],
        ),
        quantity: Decimal.parse(item.quantity.toString()),
        price: item.price != null ? Decimal.parse(item.price.toString()) : null,
        discountedPrice: item.discountedPrice != null
            ? Decimal.parse(item.discountedPrice.toString())
            : null,
        sackPrice: sackPrice,
        sackPriceId: item.sackPriceId,
        sackType: _parseSackType(item.sackType),
        perKiloPrice: perKiloPrice,
        perKiloPriceId: item.perKiloPriceId,
        saleId: item.saleId,
        isGantang: item.isGantang,
        isSpecialPrice: item.isSpecialPrice,
        isDiscounted: item.isDiscounted,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
    }).toList();
  }

  SackType? _parseSackType(String? type) {
    if (type == null) return null;
    return SackType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => SackType.FIFTY_KG,
    );
  }
}
