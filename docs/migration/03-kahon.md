# Kahon — Offline-First Migration

## Status: To Do

## Critical: Chronological Ordering

Kahon operations are **chronologically critical**. Cell edits, formula updates, and row reorders must be synced in the exact order they were made. The outbox's `created_at` field guarantees this — entries are processed oldest-first.

## Current State
- `KahonRepository` calls server API directly for every operation
- Cell edits are sent as individual `POST`/`PATCH` requests
- Batch operations (`updateCells`, `createCells`, `updateRowPositions`) send array payloads
- Formula calculation happens locally via `math_expressions` package
- No local persistence of sheet state

## Target State
- All sheet/row/cell mutations go through outbox + local tables
- Cell edits produce individual outbox entries with chronological ordering
- UI renders from local tables immediately
- Formula calculation remains local; only value persistence goes through outbox

## Local Tables

### `local_kahons`
Kahon metadata (rarely changes).

| Field | Type |
|-------|------|
| `id` | TEXT PK |
| `name` | TEXT |
| `cashierId` | TEXT |
| `createdAt` | TEXT |
| `updatedAt` | TEXT |
| `needsRefresh` | BOOL |

### `local_sheets`
| Field | Type |
|-------|------|
| `id` | TEXT PK |
| `name` | TEXT |
| `kahonId` | TEXT |
| `columns` | INT |
| `createdAt` | INT (epoch millis) |
| `updatedAt` | INT (epoch millis) |
| `needsRefresh` | BOOL |

### `local_rows`
| Field | Type |
|-------|------|
| `id` | TEXT PK |
| `rowIndex` | INT |
| `sheetId` | TEXT FK → local_sheets.id |
| `isItemRow` | BOOL |
| `itemId` | TEXT? |
| `createdAt` | INT |
| `updatedAt` | INT |
| `synced` | BOOL |

### `local_cells`
| Field | Type |
|-------|------|
| `id` | TEXT PK |
| `columnIndex` | INT |
| `rowId` | TEXT FK → local_rows.id |
| `color` | TEXT? |
| `kahonItemId` | TEXT? |
| `value` | TEXT? |
| `formula` | TEXT? |
| `isCalculated` | BOOL |
| `createdAt` | INT |
| `updatedAt` | INT |
| `synced` | BOOL |
| `localUpdatedAt` | INT (epoch millis, for conflict resolution) |

### `local_kahon_items`
| Field | Type |
|-------|------|
| `id` | TEXT PK |
| `name` | TEXT |
| `quantity` | REAL |
| `kahonId` | TEXT |
| `createdAt` | INT |
| `updatedAt` | INT |
| `needsRefresh` | BOOL |

## Write Flow — Cell Edit

```
User edits cell value →
  KahonLocalRepository.updateCell(cellId, value, color, formula) →
    1. Update local_cells row (optimistic)
    2. Write outbox entry:
       feature: 'kahon'
       operation: 'update'
       endpoint: '/sheet/cell/$cellId'
       method: 'PATCH'
       entityId: cellId
       clientCuid: cellId (already exists)
       payload: { value, color, formula }
       createdAt: DateTime.now()
    3. UI re-renders from local_cells immediately
```

## Write Flow — Batch Cell Update

```
User performs operation affecting multiple cells →
  KahonLocalRepository.updateCells(cells) →
    1. Update all affected local_cells rows
    2. Write SINGLE outbox entry (batch is a logical unit):
       feature: 'kahon'
       operation: 'update'
       endpoint: '/sheet/cells'
       method: 'PATCH'
       payload: { cells: [...] }
    3. UI re-renders
```

## Write Flow — Row Reorder

```
User drags row to new position →
  KahonLocalRepository.updateRowPositions(updates) →
    1. Update local_rows rowIndex values
    2. Write outbox entry:
       endpoint: '/sheet/rows/positions/batch'
       payload: { updates: [...] }
    3. If formulas are affected → additional outbox entry for formula batch update
```

## Chronological Ordering Guarantees

- Every cell edit creates an outbox entry with `createdAt` = `DateTime.now().millisecondsSinceEpoch`
- `SyncEngine` processes entries with `ORDER BY created_at ASC`
- Even if two cell edits happen in rapid succession, their millisecond timestamps determine order
- For truly simultaneous operations, the order within the batch payload matters — the server processes array elements in order

## Formula Handling

- **Local**: Formula evaluation uses existing `math_expressions` library and runs against `local_cells` values — works offline
- **Sync**: Only the final cell VALUES are synced to the server (not formulas, unless the cell has a formula field)
- **Calculated cells**: `isCalculated=true` cells are always computed locally; they are never written to outbox (only their formula definitions are)
- **Cross-cell references**: When a cell's value changes, formulas referencing it recalculate locally against `local_cells` data

## Conflict Resolution

With last-write-wins by timestamp:
- Each `local_cells` row has `localUpdatedAt` (epoch millis) and `updatedAt` (server timestamp)
- On fetch from server: if `localUpdatedAt` > server's `updatedAt` AND `synced=0` → skip (local version is newer, will sync later)
- On fetch from server: if `localUpdatedAt` < server's `updatedAt` → overwrite (server is newer)
- This prevents race conditions where a pending local edit gets clobbered by a server fetch

## Files to Create/Modify

### Create
- `lib/features/kahon/data/local/kahon_local_repository.dart`

### Modify
- `lib/features/kahon/data/repository/kahon_repository.dart` → split into `KahonLocalRepository` + `KahonRemoteRepository`
- `lib/features/kahon/data/providers/` → read from local repository
