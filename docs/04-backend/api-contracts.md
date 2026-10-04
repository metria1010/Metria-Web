> Purpose: Core architecture and execution specification
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# API Contracts

## Boundary rules
All route handlers/actions parse a Zod schema, require session where applicable, derive tenant from membership rather than trusting client input, verify permissions, use parameterized Supabase/RPC calls, return typed errors, and attach correlation ID. Never accept client-supplied `created_by`, admin role, payout amount, or tenant without validating against authenticated membership.

| Operation | Contract | Authorization | Idempotency / result |
|---|---|---|---|
| POST `/api/imports/preview` | offering/assessment ID, CSV rows; ≤10 MiB/10k rows | staffed offering | creates expiring preview and counts; no marks writes |
| POST `/api/imports/{id}/confirm` | batch UUID + idempotency key | offering staff | atomic apply, same result on retry |
| RPC `book_slot` | tenant, period, slot UUID | active enrolled student | transaction lock; booking ID or typed conflict |
| RPC `change_mark_from_objection` | objection UUID, score, reason | assigned offering staff | mark + history + audit in one transaction |
| POST `/api/visits` | allowlisted page/entity IDs, consent token | public, rate-limited | rotates daily salted hash; no raw IP stored |
| POST `/api/reports` | content type/id, reason | member or rate-limited anonymous | dedupe window and moderation queue |
| RPC `close_revenue_month` | tenant/month | platform revenue permission | immutable allocations; correction via adjustment entry |

Error envelope: `{code, message, correlationId, fieldErrors?}`. Stable codes: `unauthenticated`, `forbidden`, `not_found`, `validation_error`, `conflict`, `slot_full`, `already_booked`, `batch_expired`, `rate_limited`, `temporarily_unavailable`. Do not expose SQL errors or existence across tenants.

Visit endpoint drops raw IP before persistence, filters known crawlers and rate spikes, ignores no-JS requests, and stores only page attribution + daily rotating salted visitor hash. Public cache never includes session-specific data.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
