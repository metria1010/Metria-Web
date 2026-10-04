> Purpose: Core architecture and execution specification
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Edge Functions, Queues, and Jobs

Use Supabase Edge Functions for consent-aware visit ingestion, provider callbacks, and scheduled worker entry points. Keep business transactions in Postgres RPCs. `outbox_jobs` contains event type, minimal payload, idempotency key, status, attempt count, `next_attempt_at`, and timestamps. Worker claims rows with `FOR UPDATE SKIP LOCKED`, validates schema, sends via adapter, records result, and retries exponential backoff with jitter; bounded attempts move to `dead_letters`. Replay requires platform permission and appends audit event.

| Job | Schedule | Idempotency | Failure behavior |
|---|---|---|---|
| Outbox delivery | every minute | event/dedupe key | exponential retry then DLQ |
| Booking reminders | every 5 minutes | booking + reminder offset | no duplicate delivery |
| Visit aggregation | hourly | partition/date/page grouping | rerunnable upsert |
| Raw visit purge | daily | partition month | alert if partition removal fails |
| Calendar token expiry | daily | token ID | revocation idempotent |
| Sponsor expiry | every 15 minutes | creative ID | resolution excludes expired rows even before job |
| Review aggregate refresh | hourly | subject/type/window | threshold checked at read too |
| Partition creation | monthly, 7 days before month end | month | alert and block ingest to missing partition |
| Revenue close | monthly, admin-triggered then scheduled proposal | tenant/month | immutable close; adjustments append |

All jobs use secrets in Supabase vault, structured logs, per-job timeout and concurrency ceiling. Cron endpoints verify `CRON_SECRET`. Manual replay cannot edit original payload or bypass tenant rules.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
