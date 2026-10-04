> Purpose: Module requirements and acceptance criteria
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

# Chatbot

Feature IDs: 12.1-12.2. Phase: P2/P3. Owner lane: B.

## User stories
- Given an authenticated member with the assigned role, when they use a module operation, then the server and database enforce that role and the active tenant.
- Given a caller from another tenant, when they guess an identifier, then they receive no row or mutation and learn nothing about the target.
- Given a retried request, when it carries an idempotency key, then it creates one durable outcome.

## Screens, routes and rendering
Private views live under `/app/`, require an authenticated session, set `noindex`, and implement loading, empty, error, and success states. Public views read only through explicitly whitelisted `public_*` views/functions and only published content. No public response includes student names, emails, roll numbers, marks, or booking identities. Auth pages never load ad scripts.

## Data and authorization
Tables: `ai_usage`. Every table has tenant scope, RLS enabled and forced, tenant-leading indexes, and timestamps. Same-tenant composite foreign keys are used for declared parent relationships. The SQL files are the schema and policy contract. Privileged writes use private RPCs; service-role credentials stay in Edge Functions/cron. Sensitive values have append-only history and immutable audit events.

## UX, notifications, audit and analytics
All inputs are Zod-validated at the server boundary. UI is mobile-first and WCAG 2.1 AA. Notifications are inserted into the outbox with dedupe keys; delivery retries exponentially and moves to DLQ after bounded attempts. Audit sensitive mutations with actor, target, timestamp, and allowlisted payload. Analytics events omit marks, message content, email, and roll number.

## Ads, SEO and feature flags
Resolve ad slots from page type and consent configuration. Reserve slot geometry to keep CLS below 0.1; isolate scripts and keep action buttons clear. Public routes define canonical, title, description, structured data, internal links and cache invalidation. P2/P3 capabilities default off using the registry flag.

## Acceptance and tests
Given allowed and denied users from two universities, when select/insert/update/delete operations run, then pgTAP proves authorized operations succeed and unauthorized/cross-tenant operations fail. Unit tests cover validation and calculations; Playwright covers route states and core journey. Add explicit idempotency and concurrency tests to booking, import, swap, objection, waitlist, and payout cards.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
