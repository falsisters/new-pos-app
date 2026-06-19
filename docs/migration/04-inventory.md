# Inventory — Offline-First Migration

## Status: To Do

## Overview

Inventory is structurally identical to Kahon (sheets → rows → cells). The migration follows the same pattern. Much of the local repository logic can be shared or parameterized.

## Current State
- `InventoryRepository` calls server API directly
- Same cell/row/sheet operations as Kahon with `/inventory/*` endpoints
- Shared widgets with Kahon module (row_cell_data, cell_change, cell_color_handler)
- No local persistence

## Target State
- Identical outbox + local table pattern as Kahon
- Chronological ordering for cell operations
- Formula calculation local; persistence through outbox
- Last-write-wins conflict resolution

## Local Tables

### `local_inventory`
| Field | Type |
|-------|------|
| `id` | TEXT PK |
| `name` | TEXT |
| `cashierId` | TEXT |
| `createdAt` | TEXT |
| `updatedAt` | TEXT |
| `needsRefresh` | BOOL |

### `local_inventory_sheets`
| Field | Type |
|-------|------|
| `id` | TEXT PK |
| `name` | TEXT |
| `inventoryId` | TEXT |
| `columns` | INT |
| `createdAt` | INT |
| `updatedAt` | INT |
| `needsRefresh` | BOOL |

### `local_inventory_rows`
| Field | Type |
|-------|------|
| `id` | TEXT PK |
| `rowIndex` | INT |
| `inventorySheetId` | TEXT FK → local_inventory_sheets.id |
| `isItemRow` | BOOL |
| `itemId` | TEXT? |
| `createdAt` | INT |
| `updatedAt` | INT |
| `synced` | BOOL |

### `local_inventory_cells`
| Field | Type |
|-------|------|
| `id` | TEXT PK |
| `columnIndex` | INT |
| `inventoryRowId` | TEXT FK → local_inventory_rows.id |
| `color` | TEXT? |
| `inventoryItemId` | TEXT? |
| `value` | TEXT? |
| `formula` | TEXT? |
| `isCalculated` | BOOL |
| `createdAt` | INT |
| `updatedAt` | INT |
| `synced` | BOOL |
| `localUpdatedAt` | INT |

## Operation Mapping

| Kahon Endpoint | Inventory Endpoint |
|---------------|-------------------|
| `/sheet/date` | `/inventory/date` |
| `/sheet/cell` | `/inventory/cell` |
| `/sheet/cells` | `/inventory/cells` |
| `/sheet/calculation-row` | `/inventory/calculation-row` |
| `/sheet/calculation-rows` | `/inventory/calculation-rows` |
| `/sheet/cell/{id}` | `/inventory/cell/{id}` |
| `/sheet/row/{id}` | `/inventory/row/{id}` |
| `/sheet/rows/positions/batch` | `/inventory/rows/positions/batch` |
| `/sheet/cells/formulas/batch` | `/inventory/cells/formulas/batch` |
| `/sheet/reorder/comprehensive` | `/inventory/reorder/comprehensive` |
| `/sheet/reorder/validate` | `/inventory/rows/validate` |

## Implementation Note

Since Kahon and Inventory share identical structure:
- Consider a shared `spreadsheet_local_repository.dart` base class or mixin
- The only difference is the endpoint prefix (`/sheet/` vs `/inventory/`) and the local table names
- `local_kahon_tables.dart` and `local_inventory_tables.dart` are separate because Drift tables are static, but the repository logic can be DRY

## Files to Create/Modify

### Create
- `lib/features/inventory/data/local/inventory_local_repository.dart`

### Modify
- `lib/features/inventory/data/repository/inventory_repository.dart` → split into local + remote
- `lib/features/inventory/data/providers/` → read from local repository

### Consider
- Extract shared spreadsheet offline logic into `lib/core/database/spreadsheet_local_repository.dart`

## Backend Route Gap

**Critical**: `POST /inventory/cells` (addCells) uses `createMany` which returns `{ count: N }` — not the actual created records. This must be changed to use individual creates that return entities so the SyncEngine can upsert into local tables with the correct server-side IDs.

| Endpoint | Method | Current Return | Required |
|----------|--------|---------------|----------|
| `/inventory/cell` | POST | InventoryCell entity | OK |
| `/inventory/cell/:id` | PATCH | InventoryCell entity | OK |
| `/inventory/cell/:id` | DELETE | InventoryCell entity | OK |
| `/inventory/cells` | POST | `{ count: N }` | **Must return Cell[]** |
| `/inventory/cells` | PATCH | InventoryCell[] | OK |
| `/inventory/row` | POST | InventoryRow entity | OK |
| `/inventory/row/:id` | DELETE | InventoryRow entity | OK |
