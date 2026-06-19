# Stocks / Transfers — Offline-First Migration

## Status: To Do

## Current State
- `StocksRepository` calls server API
- Transfer operations (kahon, own consumption, return to warehouse, repack)
- Product price editing (sack price, per kilo price, special price)
- No local persistence

## Target State
- Transfer history cached in `local_entities` JSON cache
- Transfer creation goes through outbox
- Price edits go through Products offline flow (see 02-products.md)

## Storage Strategy

Stocks/Transfers use **`local_entities` JSON cache** because:
- Transfer list is history display
- Create transfer is a single operation
- Price edits are handled separately through Products local tables

## Write Flow

```
Create Transfer →
  1. Write to local_entities (entity_type='transfer', data=TransferModel JSON)
  2. Write outbox entry:
     feature: 'stocks'
     operation: 'create'
     endpoint: '/stocks/transfer' (verify actual endpoint)
     method: 'POST'
     payload: TransferProductRequest JSON
```

## Price Edits

Price edits (sack price, per kilo price, special price) are handled through the Products offline flow:
- Update `local_sack_prices` / `local_per_kilo_prices` tables
- Write outbox entry with `feature: 'products'`
- See 02-products.md for details

## Files to Create

- `lib/features/stocks/data/local/stocks_local_repository.dart`
