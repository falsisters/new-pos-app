# Auth / Cashier — Offline-First Migration

## Status: To Do

## Critical: No Offline Auth

Auth is the **only feature that cannot work offline**. The JWT token must be obtained from the server while online. However, we cache the cashier identity for offline display.

## Current State
- Login: POST credentials → server returns JWT
- JWT stored in `FlutterSecureStorage`
- `CashierJwtModel` contains: id, name, userId, secureCode, permissions[]
- `authProvider` checks for existing token on startup
- Token required for all API calls

## Target State
- Cashier identity cached in `local_entities` for offline display
- Auth flow remains server-dependent (no outbox for login)
- Sync engine checks auth before processing outbox
- On 401 during sync: pause sync, prompt user to re-login

## Storage

### `local_entities` entry
```
entity_type: 'cashier'
id: cashier.id
data: CashierJwtModel JSON { id, name, userId, secureCode, permissions[] }
```

Stored after successful login. Used for:
- Displaying cashier name in UI when offline
- Checking permissions locally (cached permissions allow/disallow feature access)
- Shift attribution

## Offline Behavior

### App Startup (offline)
1. Check `FlutterSecureStorage` for JWT
2. If JWT exists → check `local_entities` for cached cashier
3. If both exist → show HomeScreen (assume authenticated)
4. Sync engine will verify token when online (if 401 → force logout)

### Token Expiry While Offline
1. Sync engine attempts to process outbox
2. Receives 401 from server
3. Sync engine pauses, notifies user via sync state
4. User must re-login (requires network) before sync resumes
5. Outbox entries are NOT lost — they remain pending

### Permission Changes
- Permissions are cached from last login
- If server grants/revokes permissions while offline, cached permissions still apply
- On next successful sync, permissions are refreshed from server response
- For security-critical operations, consider re-validating on reconnect

## What Does NOT Go Through Outbox

- Login
- Logout
- Token refresh (if implemented)
- Password changes

These are online-only operations by nature.

## Files to Create

- `lib/features/auth/data/local/auth_local_repository.dart` (cache cashier, read permissions)
