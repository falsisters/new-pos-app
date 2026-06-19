# Sales — Offline-First Migration

## Status: To Do

## Current State
- `SalesRepository` calls server API directly via `DioClient`
- `SalesQueueService` holds in-memory `List<PendingSale>` with 2-second periodic retry
- No local persistence — queue lost on app restart
- UI reads from API response, displays from Riverpod state

## Target State
- Sales mutations go through `outbox_entries` + `local_sales` / `local_sale_items`
- `SalesQueueService` removed; replaced by outbox
- UI reads from `local_sales` / `local_sale_items` (offline-capable)
- Server sales from last 24 hours cached locally on fetch

## Local Tables

### `local_sales`
Mirrors `SaleModel` API response shape (flat).

| Field | Type | Source |
|-------|------|--------|
| `id` | TEXT PK | Server CUID (or client CUID if pending) |
| `cashierId` | TEXT | SaleModel.cashierId |
| `totalAmount` | REAL | SaleModel.totalAmount (Decimal → double) |
| `paymentMethod` | TEXT | Cash, Check, BankTransfer |
| `discount` | REAL? | SaleModel.discount |
| `orderId` | TEXT? | SaleModel.orderId |
| `createdAt` | TEXT | ISO string from server |
| `updatedAt` | TEXT | ISO string from server |
| `synced` | BOOL | 0=pending, 1=confirmed on server |
| `localUpdatedAt` | INT | Epoch millis for conflict resolution |

### `local_sale_items`
Mirrors `SaleItem` API response shape (flat, denormalized).

| Field | Type | Source |
|-------|------|--------|
| `id` | TEXT PK | SaleItem.id |
| `saleId` | TEXT FK | References local_sales.id |
| `productId` | TEXT | SaleItem.productId |
| `productName` | TEXT | SaleItem.product.name |
| `productPicture` | TEXT | SaleItem.product.picture |
| `quantity` | REAL | SaleItem.quantity |
| `price` | REAL? | SaleItem.price |
| `discountedPrice` | REAL? | SaleItem.discountedPrice |
| `sackPriceId` | TEXT? | SaleItem.sackPriceId |
| `sackType` | TEXT? | FIFTY_KG / TWENTY_FIVE_KG / FIVE_KG |
| `perKiloPriceId` | TEXT? | SaleItem.perKiloPriceId |
| `isGantang` | BOOL | SaleItem.isGantang |
| `isSpecialPrice` | BOOL | SaleItem.isSpecialPrice |
| `isDiscounted` | BOOL | SaleItem.isDiscounted |
| `sackPricePrice` | REAL? | Denormalized from SackPrice for display |
| `perKiloPricePrice` | REAL? | Denormalized from PerKiloPrice for display |
| `synced` | BOOL | 0=pending, 1=confirmed |

## Write Flow

```
User taps "Checkout" →
  AsyncNotifier.createSale(CreateSaleRequestModel) →
    SalesLocalRepository.createSale() →
      1. Generate client CUID for the sale
      2. Write to local_sales (id=clientCuid, synced=0)
      3. Write to local_sale_items (id=cuid for each item, synced=0)
      4. Write to outbox_entries (endpoint='/sale/create', method='POST', payload=CreateSaleRequestModel JSON)
      5. UI re-renders from local_sales immediately
```

## Read Flow

```
SalesHistory screen loads →
  AsyncNotifier.getSales(date) →
    SalesLocalRepository.getSales(date) →
      1. Read local_sales + join local_sale_items by date
      2. Return results immediately (offline-capable)
      3. If connected: fetch from server, upsert into local tables, emit update
```

## Sync Flow

```
SyncEngine processes outbox entry for sale →
  POST /sale/create
    Headers: Idempotency-Key, X-Client-Cuid
    Body: CreateSaleRequestModel JSON
  On success (200/201):
    Server returns created SaleModel
    → Update local_sales: id = server.id, synced=1
    → Update local_sale_items: id = server.item.id, synced=1
    → Mark outbox entry synced
  On 409 (idempotency conflict):
    → Already processed, mark outbox entry synced
```

## Server Fetch (Cache 24 hours)

```
When online and sales screen loads →
  GET /sale/recent/cashier?date=YYYY-MM-DD
  For each server sale:
    If local_sales has matching id AND synced=1 → update
    If local_sales has matching id AND synced=0 → skip (pending local)
    If no local match → insert
  Remove local sales not in server response (only those with synced=1)
```

## Files to Create/Modify

### Create
- `lib/features/sales/data/local/sales_local_repository.dart`

### Modify
- `lib/features/sales/data/repository/sales_repository.dart` → renamed to `SalesRemoteRepository` or kept as remote datasource
- `lib/features/sales/data/services/sales_queue_service.dart` → removed
- `lib/features/sales/data/providers/sales_provider.dart` (or equivalent) → read from local repository

### Remove
- `lib/features/sales/data/services/sales_queue_service.dart`
- `lib/features/sales/data/model/pending_sale.dart` (no longer needed)

## Backend Route Status

All sales mutation endpoints already return full entities with relations.

| Endpoint | Method | Returns | Status |
|----------|--------|---------|--------|
| `/sale/create` | POST | Full SaleModel + SaleItem[] | OK |
| `/sale/:id` | PUT | Full updated SaleModel | OK |
| `/sale/:id` | DELETE | Full voided SaleModel | OK |
| `/sale/recent/cashier` | GET | Full SaleModel[] with relations | OK |
