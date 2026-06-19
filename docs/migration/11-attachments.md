# Attachments — Offline-First Migration

## Status: To Do

## Current State
- `AttachmentRepository` calls server API
- File upload (image picker → server)
- Four types: Expense Receipt, Checks/Bank Transfer, Inventories, Supporting Documents
- No local persistence

## Target State
- Attachment metadata cached in `local_entities` JSON cache
- File upload requires network — cannot work fully offline
- Attachment metadata creation goes through outbox (file upload deferred until online)

## Storage Strategy

Attachments use **`local_entities` JSON cache** because:
- Simple metadata (id, name, url, type)
- Actual file upload needs network

## Offline Limitation

Attachments are the **one feature that truly requires network** for the core operation (file upload). The plan:

1. **Metadata first**: When user selects a file offline:
   - Save file path locally (temporary)
   - Write metadata to local_entities
   - Write outbox entry with metadata only (no file yet)

2. **File upload on sync**: When online and this outbox entry is processed:
   - Sync engine detects attachment feature
   - Reads the local file from path
   - Uses multipart upload (FormData) to POST to server
   - Updates local_entities with server URL

3. **Pending indicator**: UI shows "pending upload" badge on attachments not yet synced

## Write Flow

```
Select File (offline) →
  1. Copy file to app temp directory
  2. Write to local_entities (entity_type='attachment', data=metadata JSON)
  3. Write outbox entry:
     feature: 'attachments'
     operation: 'create'
     endpoint: '/attachment/create'
     method: 'POST'
     payload: CreateAttachmentRequest JSON (name, type)
     Note: file will be attached by sync engine when processing
```

## Files to Create

- `lib/features/attachments/data/local/attachments_local_repository.dart`
