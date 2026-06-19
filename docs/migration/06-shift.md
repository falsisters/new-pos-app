# Shift — Offline-First Migration

## Status: To Do

## Critical: Shift Gate

The shift system gates the entire app. No operations are allowed without an active shift. This makes shift the **highest priority** feature to handle correctly offline:

- Shift **creation** must succeed before any other offline operation
- If the user was offline when shift ended, they need awareness
- Shift end must be recorded and synced

## Current State
- `ShiftNotifier` fetches shifts from server, checks for active shift (endTime==null)
- Shift dialog blocks UI until shift is created
- Shift creation/editing calls server API directly
- No local persistence

## Target State
- Shift data cached in `local_entities` JSON cache
- Shift start/end go through outbox
- Local shift state determines app behavior when offline

## Storage Strategy

Shifts use **`local_entities` JSON cache** because:
- Simple data (id, employees[], startTime, endTime)
- Single active shift at a time
- No complex querying needed

## Offline Behavior

### Shift Active (offline)
- App operates normally — shift is locally cached
- All other features' outbox entries accumulate
- Sync engine will push them when online with valid token

### Shift End (offline)
```
User ends shift →
  1. Update local_entities: shift.endTime = now
  2. Write outbox entry:
     feature: 'shift'
     operation: 'update'
     endpoint: '/shift/{id}/end'
     method: 'POST'
```

### Startup (offline)
1. Read local_entities for latest shift
2. If cached shift has endTime==null → assume shift is active
3. Show normal UI (no shift dialog)
4. When coming online, verify with server — if server says shift ended differently, reconcile

### Token Expiry
The one case where offline-first hits a wall:
- If the JWT token expires while offline, sync cannot happen
- User must log in again and get a valid token before outbox entries can be pushed
- The sync engine checks auth state before processing — if 401, pauses sync and notifies user

## Files to Create

- `lib/features/shift/data/local/shift_local_repository.dart`
