# Offline-First Architecture — Migration Plan

## Overview

Falsisters POS is moving from a purely online-first architecture to an offline-first architecture using the **Outbox Pattern** with **Drift (SQLite ORM)**.

### Core Concept

```
[Mutation] → Outbox Table (pending) → SyncEngine → Server API
                  ↓
[Local Entity Tables] ← updated optimistically for immediate UI display
```

Every mutation (create/update/delete) is:
1. Written to the **outbox** table with `status=pending` and an idempotency key
2. Also written to the local entity tables so the UI can render immediately
3. Synced to the server by `SyncEngine` when online, in chronological order
4. On sync success: outbox entry marked `synced`, local entity marked `synced=1`

### Key Design Decisions

- **Local tables mirror API response shapes**, not Prisma schema relations
- **Outbox is the single source of truth** for pending mutations
- **Chronological ordering**: all outbox entries processed in `created_at` order (critical for Kahon/Inventory cell operations)
- **Idempotency keys**: every outbox entry gets a unique key; server uses it to prevent duplicate processing
- **Client CUIDs**: client generates CUIDs for all new entities; server accepts client CUID OR generates its own if not provided (via `X-Client-Cuid` header)
- **Conflict resolution**: last-write-wins by timestamp
- **24-hour cache**: on fetch, server data from last 24 hours is upserted into local tables so offline mode doesn't start blank
- **Auth caching**: cashier identity is cached locally for offline display; syncing requires valid token

### Data Flow

**Write (offline):**
```
UI → AsyncNotifier → LocalRepository → Drift DB (local tables + outbox)
                                         ↓
                                    UI re-renders immediately from local DB
```

**Sync (when online):**
```
SyncEngine → reads outbox (pending, ordered by created_at)
           → sends HTTP request with Idempotency-Key + X-Client-Cuid headers
           → on success: updates local entity with server response, marks synced
           → on 409 (duplicate): marks synced (already processed)
           → on 4xx: marks failed (don't retry)
           → on 5xx/network: increments retry count, backoff
```

**Read:**
```
UI → AsyncNotifier → LocalRepository.read() → Drift DB (immediate, works offline)
                                                ↓
                         (if connected) → RemoteRepository → Server API
                                                ↓
                                          Upsert into local DB → emit update
```

---

## Implementation Phases

### Phase 0: Scaffold (Current)
- [x] Dependencies installed (drift, sqlite3_flutter_libs, path_provider, connectivity_plus)
- [x] Database schema defined (all tables)
- [x] Converters (Decimal, DateTime)
- [x] Core sync infrastructure skeletons (IdempotencyService, ConnectivityService, SyncEngine, SyncState, DioInterceptor)
- [x] Run `build_runner` to generate `database.g.dart`
- [x] Initialize database in `main.dart` (applyDriftNativeOptions, getInstance)
- [x] Create Riverpod provider for `AppDatabase`

### Phase 1: Sync Core (Next)
- [x] Implement `SyncEngine.syncAll()` fully
- [x] Implement `SyncEngine.syncFeature(feature)` — per-feature sync
- [x] Implement `SyncEngine.pullAndMerge(entityType, apiEndpoint)` — server fetch → upsert logic
- [x] Add `DioIdempotencyInterceptor` to `DioClient`
- [x] Create `AppDatabase` Riverpod provider
- [x] Wire connectivity listener to trigger sync
- [x] Create pending count badge in UI (sync status indicator)

### Phase 2: Sales (First Feature Migration)
- [x] Create `lib/features/sales/data/local/sales_local_repository.dart`
  - `createSale()` → write to local_sales + local_sale_items + outbox
  - `getSales({DateTime? date})` → read from local DB; optionally refresh from server
  - `deleteSale(id)` → soft delete + outbox
- [x] Refactor `SalesQueueService` → removed; using outbox
- [x] Refactor `SalesRepository` → `SalesLocalRepository` + `SalesRemoteRepository`
- [x] Update sales Riverpod providers to read from local DB first
- [x] Update `SaleModel.fromJson` → write through to local tables
- [x] Update sales check / sales history screens to work offline

### Phase 3: Products
- [ ] Create `lib/features/products/data/local/products_local_repository.dart`
- [ ] Cache products on first fetch; refresh when online
- [ ] Products are reference data — upserted from server periodically

### Phase 4: Kahon (Chronologically Critical)
- [ ] Create `lib/features/kahon/data/local/kahon_local_repository.dart`
- [ ] Cell updates → individual outbox entries with chronological ordering
- [ ] Batch updates (`updateCells`, `createCells`) → single outbox entry with array payload
- [ ] Formula calculation still local (existing `math_expressions`); only value persistence through outbox
- [ ] Row reorder operations → outbox with comprehensive payload

### Phase 5: Inventory
- [ ] Same pattern as Kahon (structurally identical)
- [ ] Create `lib/features/inventory/data/local/inventory_local_repository.dart`

### Phase 6: Remaining Features (Orders → Auth)
- [ ] Orders + Customers (local_entities JSON cache + outbox)
- [ ] Shift (local_entities + outbox — shift lock gates entire app)
- [ ] Deliveries (local_entities + outbox)
- [ ] Expenses (local_entities + outbox)
- [ ] Stocks/Transfers (local_entities + outbox)
- [ ] Bill Count (local_entities + outbox)
- [ ] Attachments (local_entities + outbox; file uploads need network)
- [ ] Cashier/Auth (local_entities cache only; no outbox for auth)
- [ ] Sales Check (computed from local_sales — no separate tables)
- [ ] Profits (computed from local_sales + local_products — no separate tables)

---

## Schema Reference

### Outbox Table (`outbox_entries`)
The universal mutation queue. Every create/update/delete across all features goes here.

| Column | Type | Purpose |
|--------|------|---------|
| `id` | TEXT PK | Client CUID for the outbox entry |
| `feature` | TEXT | `'sales'`, `'kahon'`, `'inventory'`, etc. |
| `operation` | TEXT | `'create'`, `'update'`, `'delete'` |
| `endpoint` | TEXT | API path, e.g., `'/sale/create'` |
| `method` | TEXT | `'POST'`, `'PATCH'`, `'DELETE'` |
| `entity_id` | TEXT? | Server ID of entity (null for creates) |
| `client_cuid` | TEXT | Client-generated CUID for the entity |
| `payload` | TEXT | JSON request body |
| `idempotency_key` | TEXT UNIQUE | Generated by IdempotencyService |
| `created_at` | INT | Epoch millis — determines sync order |
| `synced_at` | INT? | Epoch millis when synced |
| `sync_attempts` | INT DEFAULT 0 | Max 5 before marked failed |
| `status` | TEXT DEFAULT 'pending' | `pending`, `syncing`, `synced`, `failed` |
| `error` | TEXT? | Last error message |
| `priority` | INT DEFAULT 0 | Higher = synced first |

### Local Entity Tables
- **Sales**: `local_sales`, `local_sale_items` — full flat mirror of API response
- **Products**: `local_products`, `local_sack_prices`, `local_per_kilo_prices`
- **Kahon**: `local_kahons`, `local_sheets`, `local_rows`, `local_cells`, `local_kahon_items`
- **Inventory**: `local_inventory`, `local_inventory_sheets`, `local_inventory_rows`, `local_inventory_cells`
- **Everything else**: `local_entities` — keyed by `(id, entity_type)`, stores full JSON in `data` column

### Generic Cache Table (`local_entities`)
For features that don't need fine-grained local querying (Orders, Deliveries, Expenses, Stocks, Bill Count, Attachments, Shift, Auth).

| Column | Type | Purpose |
|--------|------|---------|
| `id` | TEXT | Server ID |
| `entity_type` | TEXT | `'order'`, `'expense_list'`, etc. |
| `data` | TEXT | Full JSON of API response |
| `updated_at` | INT | Epoch millis |
| `needs_refresh` | BOOL DEFAULT 0 | Re-fetch from server on next sync |

PRIMARY KEY (`id`, `entity_type`)

---

## Server Contract (Backend Changes Needed)

The server must support:

1. **Idempotency-Key header**: If a request with the same key arrives, return `409 Conflict` with the original response body (not an error). Server stores idempotency keys with a reasonable TTL.

2. **X-Client-Cuid header**: For `POST`/create operations, the server should:
   - Use the client CUID as the entity's primary key if provided
   - Generate its own CUID if not provided
   - Return the final ID in the response (so client can update local record)

3. **Timestamp-based conflict resolution**: All entities have an `updatedAt` field. When merging during fetch, client compares local vs server timestamps.

4. **All endpoints must return the created/updated entity** in the response body, not just a success message.

---

## Sync Merge Logic

When fetching from server (e.g., last 24 hours of sales):

```
for each server record:
  if exists locally:
    if local.synced == true:
      update local row with server data (server is authority)
    else:
      skip (pending local mutation not yet synced)
  else:
    insert new local row

for each local record:
  if not in server response AND synced == true:
    remove locally (server deleted it)
```

---

## File Structure

```
lib/core/
├── database/
│   ├── database.dart                   # @DriftDatabase + singleton
│   ├── database.g.dart                 # Generated by drift_dev
│   ├── tables/
│   │   ├── outbox_entries.dart         # Outbox table
│   │   ├── local_entities.dart         # Generic JSON cache
│   │   ├── local_sales_tables.dart     # Sales + SaleItems
│   │   ├── local_products_tables.dart  # Products + Prices
│   │   ├── local_kahon_tables.dart     # Kahon: Sheets, Rows, Cells, Items
│   │   └── local_inventory_tables.dart # Inventory: Sheets, Rows, Cells
│   └── converters/
│       ├── decimal_converter.dart      # Decimal ↔ double
│       └── date_time_converter.dart    # DateTime ↔ epoch millis
└── sync/
    ├── idempotency_service.dart        # CUID2 + idempotency key generation
    ├── connectivity_service.dart       # connectivity_plus wrapper
    ├── sync_engine.dart                # Outbox processor + periodic timer
    ├── sync_state.dart                 # Riverpod state for sync status
    └── dio_idempotency_interceptor.dart # Injects Idempotency-Key header
```

---

## Guidelines for Developers

### Adding a new feature to the offline system

1. **Decide storage strategy**:
   - Complex/queryable data → proper Drift tables (like Sales, Kahon)
   - Simple/cache-only data → `local_entities` JSON cache

2. **Create local repository**: `<feature>_local_repository.dart` with:
   - Write methods → Drift DB + outbox entry
   - Read methods → Drift DB first, server refresh optionally
   - Delete methods → soft delete + outbox entry

3. **Refactor existing repository**: split into `<Feature>LocalRepository` + `<Feature>RemoteRepository`

4. **Update providers**: read from local repository (always works offline)

### Outbox entry creation

```dart
final entry = OutboxEntry(
  id: IdempotencyService.generateCuid(),
  feature: 'sales',
  operation: 'create',
  endpoint: '/sale/create',
  method: 'POST',
  clientCuid: IdempotencyService.generateCuid(), // entity's CUID
  payload: jsonEncode(request.toJson()),
  idempotencyKey: IdempotencyService.generateIdempotencyKey(),
  createdAt: DateTime.now(),
  status: 'pending',
);

await db.into(db.outboxEntries).insert(entry);
```

### Reading data offline-first

```dart
Future<List<SalesRecord>> getSales({DateTime? date}) async {
  // Always return from local DB immediately
  var query = db.select(db.localSales);
  if (date != null) {
    // filter by date
  }
  final local = await query.get();

  // If connected, trigger background refresh
  if (await connectivityService.isConnected()) {
    _refreshFromServer(date);
  }

  return local;
}
```

---

## Current Status

### Completed (Phase 0)
- [x] Dependencies installed
- [x] All Drift table definitions
- [x] Database class skeleton
- [x] Sync infrastructure skeletons
- [x] Documentation

### Next Steps (Phase 1)
- [ ] Generate `database.g.dart` via `build_runner`
- [ ] Initialize database in `main.dart`
- [ ] Fully implement `SyncEngine`
- [ ] Wire connectivity listener

### Pending
- [ ] All Phase 2–6 feature migrations
- [ ] Backend changes (idempotency keys, client CUID support)
- [ ] Unit tests for sync engine
- [ ] Integration tests for offline scenarios
