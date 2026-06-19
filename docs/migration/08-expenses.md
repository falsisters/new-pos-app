# Expenses — Offline-First Migration

## Status: To Do

## Current State
- `ExpenseRepository` calls server API
- Expense lists with items (name, amount)
- Daily batch operations
- No local persistence

## Target State
- Expense lists cached in `local_entities` JSON cache
- Expense creation goes through outbox
- Display from cache when offline

## Storage Strategy

Expenses use **`local_entities` JSON cache** because:
- Simple structure (list of name/amount pairs)
- Daily aggregated by date
- Low frequency of offline edits

## Write Flow

```
Create Expense List →
  1. Write to local_entities (entity_type='expense_list', data=ExpenseList JSON)
  2. Write outbox entry:
     feature: 'expenses'
     operation: 'create'
     endpoint: '/expense-list/create' (verify actual endpoint)
     method: 'POST'
     payload: CreateExpenseList JSON
```

## Files to Create

- `lib/features/expenses/data/local/expenses_local_repository.dart`

## Backend Route Gap

`DELETE /expenses/:id` returns a bare entity without `ExpenseItems` relation. The SyncEngine needs the full entity to reconcile the local cache correctly.

| Endpoint | Method | Current Return | Required |
|----------|--------|---------------|----------|
| `/expense-list/create` | POST | ExpenseList + ExpenseItems[] | OK |
| `/expense-list/:id` | PUT | ExpenseList + ExpenseItems[] | OK |
| `/expense-list/:id` | DELETE | ExpenseList (no relations) | **Add `include: { ExpenseItems }`** |
