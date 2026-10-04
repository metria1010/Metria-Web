> Purpose: Core architecture and execution specification
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Database Conventions

Migrations are the only schema authority. Apply local Supabase migrations in clean order and test rollback strategy. Every table uses UUID primary key, tenant scope unless explicitly global lookup, UTC timestamps, RLS enabled and forced, and least-privilege grants. Tenant-owned rows have NOT NULL `university_id`; parent references use composite tenant FKs. Add an index for every FK and common filter, including tenant-leading indexes. `updated_at` triggers are standardized. Sensitive records use append-only history. `audit_log` has no UPDATE/DELETE privileges.

Use text/check or lookup tables for growing status sets. Native enum only after ADR shows a closed set. JSONB is permitted for `settings`, `metadata`, immutable revenue snapshots, consent categories and documented sanitized rich-text representations; do not put core relational data in JSON. Money is integer minor units plus currency. Times are timestamptz. Use explicit `ON DELETE RESTRICT`; lifecycle jobs perform policy-approved purge/anonymization.

Every privileged RPC: private schema, SECURITY DEFINER only when necessary, empty search path, schema-qualified objects, validates `auth.uid()`, tenant and permission, bounded input, safe stable error code, idempotency where retryable, narrow EXECUTE grant. Use `SELECT auth.uid()` initPlan pattern in RLS. pgTAP covers each policy allow/deny/cross-tenant.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
