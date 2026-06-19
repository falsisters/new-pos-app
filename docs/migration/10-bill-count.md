# Bill Count — Offline-First Migration

## Status: To Do

## Current State
- `BillCountRepository` calls server API
- Daily cash counting with bill denominations (1000, 500, 100, 50, 20, coins)
- Beginning balance, expenses, totals
- No local persistence

## Target State
- Bill counts cached in `local_entities` JSON cache
- Bill count creation/update goes through outbox
- Display from cache when offline

## Storage Strategy

Bill counts use **`local_entities` JSON cache** because:
- Single daily document per day
- Simple structure (bills array, totals)
- Low frequency of offline edits (once per day typically)

## Write Flow

```
Create/Update Bill Count →
  1. Write to local_entities (entity_type='bill_count', data=BillCountModel JSON)
  2. Write outbox entry:
     feature: 'bill_count'
     operation: 'create' (or 'update')
     endpoint: '/bill-count/create' (verify actual endpoint)
     method: 'POST'
     payload: CreateBillCountRequestModel JSON
```

## Files to Create

- `lib/features/bill_count/data/local/bill_count_local_repository.dart`
