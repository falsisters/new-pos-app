# Orders — Offline-First Migration

## Status: To Do

## Current State
- Order operations through `OrderRepository` (server API)
- Orders link to customers (`CustomerModel`) and items (`OrderItemModel`)
- Sale can reference an order (`sale.orderId`)
- No local persistence

## Target State
- Orders + Customers stored in `local_entities` JSON cache
- Mutations go through outbox
- Simple display from cached data when offline

## Storage Strategy

Orders use the **`local_entities` JSON cache** because:
- Orders are not frequently edited offline (unlike Kahon cells)
- The order list is simple (name, status, total) — display can work from JSON
- Customer data is simple (name, userId)
- Creating separate tables for orders with items + customers would add 3+ tables for low offline-edit frequency

## Write Flow

```
Create Order →
  1. Write to local_entities (entity_type='order', data=full OrderModel JSON)
  2. Write outbox entry:
     feature: 'orders'
     operation: 'create'
     endpoint: '/order/create'
     method: 'POST'
     payload: CreateOrderRequest JSON
```

## Read Flow

```
Orders screen loads →
  OrdersLocalRepository.getAll() →
    1. Read local_entities WHERE entity_type='order'
    2. Deserialize JSON to OrderModel
    3. Return immediately
    4. If connected: fetch from server, upsert, emit update
```

## Files to Create

- `lib/features/orders/data/local/orders_local_repository.dart`
