# Deliveries — Offline-First Migration

## Status: To Do

## Current State
- `DeliveryRepository` calls server API
- Truck model with product items
- Delivery state with creation endpoint
- No local persistence

## Target State
- Deliveries cached in `local_entities` JSON cache
- Delivery creation goes through outbox
- Truck/delivery state displayed from cache when offline

## Storage Strategy

Deliveries use **`local_entities` JSON cache** because:
- Simple data (driverName, deliveryTimeStart, items[])
- Read-heavy (display list of deliveries)
- Rare edits offline

## Write Flow

```
Create Delivery →
  1. Write to local_entities (entity_type='delivery', data=TruckModel JSON)
  2. Write outbox entry:
     feature: 'deliveries'
     operation: 'create'
     endpoint: '/delivery/create' (verify actual endpoint)
     method: 'POST'
     payload: CreateDeliveryRequestModel JSON
```

## Files to Create

- `lib/features/deliveries/data/local/deliveries_local_repository.dart`
