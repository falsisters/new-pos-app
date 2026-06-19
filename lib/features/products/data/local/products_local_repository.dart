import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:falsisters_pos_android/core/database/database.dart';
import 'package:falsisters_pos_android/features/products/data/models/per_kilo_price_model.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/products/data/models/sack_price_model.dart';
import 'package:falsisters_pos_android/features/products/data/models/special_price_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';

class ProductsLocalRepository {
  final AppDatabase _db;

  ProductsLocalRepository(this._db);

  Future<void> upsertProducts(List<Product> products) async {
    for (final product in products) {
      await _upsertProduct(product);
    }
  }

  Future<void> clearAndUpsert(List<Product> products) async {
    await _db.transaction(() async {
      await _db.delete(_db.localPerKiloPrices).go();
      await _db.delete(_db.localSackPrices).go();
      await _db.delete(_db.localProducts).go();

      for (final product in products) {
        await _upsertProduct(product);
      }
    });
  }

  Future<void> _upsertProduct(Product product) async {
    await _db.into(_db.localProducts).insertOnConflictUpdate(
      LocalProductsCompanion.insert(
        id: product.id,
        name: product.name,
        picture: product.picture,
        userId: product.userId,
        createdAt: product.createdAt.toIso8601String(),
        updatedAt: product.updatedAt.toIso8601String(),
        needsRefresh: const Value(false),
        localUpdatedAt: DateTime.now(),
      ),
    );

    for (final sackPrice in product.sackPrice) {
      await _db.into(_db.localSackPrices).insertOnConflictUpdate(
        LocalSackPricesCompanion.insert(
          id: sackPrice.id,
          productId: product.id,
          price: sackPrice.price.toDouble(),
          stock: sackPrice.stock.toDouble(),
          profit: sackPrice.profit != null
              ? Value(sackPrice.profit!.toDouble())
              : const Value.absent(),
          type: sackPrice.type.name,
          hasSpecialPrice: Value(sackPrice.specialPrice != null),
          specialPricePrice: sackPrice.specialPrice != null
              ? Value(sackPrice.specialPrice!.price.toDouble())
              : const Value.absent(),
          specialPriceMinimumQty: sackPrice.specialPrice != null
              ? Value(sackPrice.specialPrice!.minimumQty)
              : const Value.absent(),
        ),
      );
    }

    if (product.perKiloPrice != null) {
      await _db.into(_db.localPerKiloPrices).insertOnConflictUpdate(
        LocalPerKiloPricesCompanion.insert(
          id: product.perKiloPrice!.id,
          productId: product.id,
          price: product.perKiloPrice!.price.toDouble(),
          stock: product.perKiloPrice!.stock.toDouble(),
          profit: product.perKiloPrice!.profit != null
              ? Value(product.perKiloPrice!.profit!.toDouble())
              : const Value.absent(),
        ),
      );
    }
  }

  Future<List<Product>> getProducts() async {
    final localProducts = await _db.select(_db.localProducts).get();
    final allSackPrices = await _db.select(_db.localSackPrices).get();
    final allPerKiloPrices = await _db.select(_db.localPerKiloPrices).get();

    final sackPricesByProduct = <String, List<LocalSackPrice>>{};
    for (final sp in allSackPrices) {
      sackPricesByProduct.putIfAbsent(sp.productId, () => []).add(sp);
    }

    final perKiloByProduct = <String, LocalPerKiloPrice>{};
    for (final pkp in allPerKiloPrices) {
      perKiloByProduct[pkp.productId] = pkp;
    }

    return localProducts.map((lp) {
      final sackPrices = (sackPricesByProduct[lp.id] ?? []).map((lsp) {
        return SackPrice(
          id: lsp.id,
          price: Decimal.parse(lsp.price.toString()),
          stock: Decimal.parse(lsp.stock.toString()),
          profit: lsp.profit != null
              ? Decimal.parse(lsp.profit.toString())
              : null,
          type: SackType.values.firstWhere(
            (e) => e.name == lsp.type,
            orElse: () => SackType.FIFTY_KG,
          ),
          productId: lsp.productId,
          createdAt: DateTime.tryParse(lp.createdAt) ?? DateTime.now(),
          updatedAt: DateTime.tryParse(lp.updatedAt) ?? DateTime.now(),
          specialPrice: lsp.hasSpecialPrice && lsp.specialPricePrice != null
              ? SpecialPrice(
                  id: '',
                  price: Decimal.parse(lsp.specialPricePrice.toString()),
                  minimumQty: lsp.specialPriceMinimumQty ?? 0,
                  sackPriceId: lsp.id,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                )
              : null,
        );
      }).toList();

      final localPKP = perKiloByProduct[lp.id];
      final perKiloPrice = localPKP != null
          ? PerKiloPrice(
              id: localPKP.id,
              price: Decimal.parse(localPKP.price.toString()),
              stock: Decimal.parse(localPKP.stock.toString()),
              profit: localPKP.profit != null
                  ? Decimal.parse(localPKP.profit.toString())
                  : null,
              productId: localPKP.productId,
              createdAt: DateTime.tryParse(lp.createdAt) ?? DateTime.now(),
              updatedAt: DateTime.tryParse(lp.updatedAt) ?? DateTime.now(),
            )
          : null;

      return Product(
        id: lp.id,
        name: lp.name,
        picture: lp.picture,
        createdAt: DateTime.tryParse(lp.createdAt) ?? DateTime.now(),
        updatedAt: DateTime.tryParse(lp.updatedAt) ?? DateTime.now(),
        userId: lp.userId,
        sackPrice: sackPrices,
        perKiloPrice: perKiloPrice,
      );
    }).toList();
  }

  Future<Product?> getProductById(String id) async {
    final localProduct = await (_db.select(_db.localProducts)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    if (localProduct == null) return null;

    final sackPrices = await (_db.select(_db.localSackPrices)
          ..where((tbl) => tbl.productId.equals(id)))
        .get();

    final perKiloPrice = await (_db.select(_db.localPerKiloPrices)
          ..where((tbl) => tbl.productId.equals(id)))
        .getSingleOrNull();

    final productSackPrices = sackPrices.map((lsp) {
      return SackPrice(
        id: lsp.id,
        price: Decimal.parse(lsp.price.toString()),
        stock: Decimal.parse(lsp.stock.toString()),
        profit: lsp.profit != null
            ? Decimal.parse(lsp.profit.toString())
            : null,
        type: SackType.values.firstWhere(
          (e) => e.name == lsp.type,
          orElse: () => SackType.FIFTY_KG,
        ),
        productId: lsp.productId,
        createdAt: DateTime.tryParse(localProduct.createdAt) ?? DateTime.now(),
        updatedAt: DateTime.tryParse(localProduct.updatedAt) ?? DateTime.now(),
        specialPrice: lsp.hasSpecialPrice && lsp.specialPricePrice != null
            ? SpecialPrice(
                id: '',
                price: Decimal.parse(lsp.specialPricePrice.toString()),
                minimumQty: lsp.specialPriceMinimumQty ?? 0,
                sackPriceId: lsp.id,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )
            : null,
      );
    }).toList();

    final resultPkp = perKiloPrice != null
        ? PerKiloPrice(
            id: perKiloPrice.id,
            price: Decimal.parse(perKiloPrice.price.toString()),
            stock: Decimal.parse(perKiloPrice.stock.toString()),
            profit: perKiloPrice.profit != null
                ? Decimal.parse(perKiloPrice.profit.toString())
                : null,
            productId: perKiloPrice.productId,
            createdAt: DateTime.tryParse(localProduct.createdAt) ?? DateTime.now(),
            updatedAt: DateTime.tryParse(localProduct.updatedAt) ?? DateTime.now(),
          )
        : null;

    return Product(
      id: localProduct.id,
      name: localProduct.name,
      picture: localProduct.picture,
      createdAt: DateTime.tryParse(localProduct.createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(localProduct.updatedAt) ?? DateTime.now(),
      userId: localProduct.userId,
      sackPrice: productSackPrices,
      perKiloPrice: resultPkp,
    );
  }
}
