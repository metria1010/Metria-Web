> Purpose: Core architecture and execution specification
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Failure Modes and Resilience

| Failure | Detection | User behavior | Recovery |
|---|---|---|---|
| Supabase Auth unavailable | health probe, Sentry | existing cached shell explains sign-in unavailable; no false success | provider status, verify callback and secrets, retry |
| Database saturation | p95/connection alerts | bounded retry for safe reads; mutation returns correlation ID | inspect slow queries, pool pressure, scale tier, restore if needed |
| Ad network broken/malvertising | QA report, CSP report, Safe Browsing check | slot collapses safely within reserved area; product remains usable | per-network/global kill switch and isolation runbook |
| Email provider outage | outbox age/DLQ | in-app notification remains; delivery marked queued | retry exponential with jitter, replay DLQ after provider recovery |
| Realtime disconnected | channel health | polling fallback with stale indicator | reconnect with backoff |
| Push permission denied | browser state | email/in-app continue | user may change preference; do not nag |
| Queue duplicate delivery | idempotency key | one logical notice | delivery dedupe and provider idempotency |
| Import worker timeout | batch state and expiry | preview remains until expiry; no partial commit | retry confirmation RPC; transaction ensures all-or-nothing |
| Booking race | conflict rate | typed `slot_full`/already-booked response | locked transactional RPC and DB uniqueness |
| Cache stale after unpublish | revalidation alert | publication state checked at source | purge ISR and sitemap; serve not-found |

Critical runbooks live in `10-ops/runbooks/`. Every background job has bounded retry, exponential backoff with jitter, dedupe key, terminal DLQ, admin visibility and replay audit.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
