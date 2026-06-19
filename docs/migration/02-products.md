# Products — Offline-First Migration

## Status: To Do

## Current State
- Products fetched from server on demand via `ProductsRepository`
- No local caching
- Products are reference data used by Sales, Deliveries, Stocks, Orders

## Target State
- Products cached in local tables on first fetch
- UI reads from local tables (offline-capable)
- Refreshed from server when online
- Product changes (rare) go through outbox + local tables

## Local Tables

### `local_products`
| Field | Type | Source |
|-------|------|--------|
| `id` | TEXT PK | Product.id |
| `name` | TEXT | Product.name |
| `picture` | TEXT | Product.picture |
| `userId` | TEXT | Product.userId |
| `createdAt` | TEXT | ISO string |
| `updatedAt` | TEXT | ISO string |
| `needsRefresh` | BOOL | Set on fetch, cleared when refreshed |
| `localUpdatedAt` | INT | Epoch millis |

### `local_sack_prices`
| Field | Type | Source |
|-------|------|--------|
| `id` | TEXT PK | SackPrice.id |
| `productId` | TEXT FK | References local_products.id |
| `price` | REAL | SackPrice.price |
| `stock` | REAL | SackPrice.stock |
| `profit` | REAL? | SackPrice.profit |
| `type` | TEXT | FIFTY_KG / TWENTY_FIVE_KG / FIVE_KG |
| `hasSpecialPrice` | BOOL | Derived from SpecialPrice presence |
| `specialPricePrice` | REAL? | SpecialPrice.price if exists |
| `specialPriceMinimumQty` | INT? | SpecialPrice.minimumQty if exists |

### `local_per_kilo_prices`
| Field | Type | Source |
|-------|------|--------|
| `id` | TEXT PK | PerKiloPrice.id |
| `productId` | TEXT FK | References local_products.id |
| `price` | REAL | PerKiloPrice.price |
| `stock` | REAL | PerKiloPrice.stock |
| `profit` | REAL? | PerKiloPrice.profit |

## Read Flow

```
ProductsScreen loads (or Sales cart loads products) →
  ProductsLocalRepository.getAll() →
    1. Read local_products + local_sack_prices + local_per_kilo_prices
    2. Reconstruct Product objects from flat rows
    3. Return immediately
    4. If connected AND local_products is empty OR needsRefresh: fetch from server
```

## Sync/Refresh Flow

```
GET /product (or equivalent endpoint) →
  For each product:
    Upsert local_products by id
    Upsert local_sack_prices by (id, productId) — delete any not in response
    Upsert or delete local_per_kilo_prices by (id, productId)
  Set needsRefresh = false
```

## Product Mutations (Edit Price, Edit Stock)

Products can be edited (though rare). These go through outbox:

```
Edit SackPrice →
  Write to local_sack_prices (optimistic update)
  Write outbox entry:
    feature: 'products'
    operation: 'update'
    endpoint: '/product/{id}/sack-price'
    method: 'PATCH'
    payload: EditSackPriceRequest JSON
    clientCuid: local_sack_prices.id (already exists)
```

## Files to Create/Modify

### Create
- `lib/features/products/data/local/products_local_repository.dart`

### Modify
- `lib/features/products/data/providers/products_provider.dart` → read from local repository
