> Purpose: Core architecture and execution specification
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Capacity, Cost, and Service Tiers

## Planning model
Estimate monthly active users (MAU), peak concurrent sessions, public page views, raw visit events, queue deliveries, database storage and egress independently. Initial launch envelope for sizing is a planning assumption, not a provider guarantee: 2,000 MAU, 100 concurrent users, 250,000 public page views/month, 50,000 private reads/month, 100,000 notification attempts/month. Load-test booking bursts and dashboard RPCs at 5× expected peak.

| Service | Development | Production position | Upgrade trigger |
|---|---|---|---|
| Vercel | Preview/dev | Paid commercial plan assumed for ad-funded service | Before monetized production; verify current commercial terms |
| Supabase | Local CLI and isolated staging | Paid project with PITR/backups and capacity headroom | Before real student records or launch; free tier lacks production guarantees and can pause |
| Email | Sandbox | Resend paid/verified domain | Before real notices; bounce or quota threshold |
| Error monitoring | Developer tier | Paid as event volume and retention require | Alert loss, retention, or quota pressure |
| Ad providers | Test placement | Approved business account and category controls | Before ad scripts in production |

Track DB size, egress, connection saturation, p95 query latency, queue age, retries, ad RPM, consent rate, CWV and cost per 1,000 sessions weekly. Upgrade before sustained 70% storage/egress/connection budget, p95 DB >300 ms for critical RPCs, or queue oldest age >5 minutes. Configure pooling and indexes before scaling compute. Verify current provider plans, commercial terms, privacy terms, payout rules and ad-network terms at execution time; they change.

Backups: PITR/daily backups enabled; restore drill before launch and quarterly. Separate staging and production projects. Never use production student data in performance fixtures.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
