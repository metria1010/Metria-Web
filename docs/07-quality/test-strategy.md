> Purpose: Testing layers, gates and data
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Test Strategy

- Unit: Vitest for grade formulas, calculator boundaries, zod contracts, ad resolver, attribution rounding, token parsing.
- Database: pgTAP for every table/policy, allowed/denied/cross-tenant paths; constraints, triggers, immutable tables and RPC atomicity.
- Integration: local Supabase + Edge Functions for outbox idempotency, retries, DLQ, consent and monthly close.
- Browser: Playwright for Google auth mocked in staging, student/TA journeys, noindex, ads, PWA, accessibility smoke, mobile widths and privacy leakage.

Required invariant suites: concurrent last-slot booking admits one; one booking per student/period; cancel/reschedule cutoff; swap mutual consent atomically exchanges slots; waitlist promotion claims capacity once; CSV preview writes zero marks and duplicate confirm is idempotent; objection-driven mark update writes mark/history/audit in same transaction; allocations/payout events cannot update/delete; public views exclude student rows; private table anon reads denied; cohort below k suppresses stats.

CI gates: formatting, lint, typecheck, unit, migration clean apply, pgTAP, build, Playwright critical path, dependency audit and secret scan. Coverage targets: 80% statements for business logic; every security policy and invariant explicitly tested even where line coverage differs. Test fixtures use synthetic identities in two tenants.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
