> Purpose: CI pipeline and release rules
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# CI/CD and Release

Every PR: install frozen lockfile; lint/format/typecheck; Vitest; build; Supabase CLI migration validation; clean local DB migration; pgTAP; Playwright critical path; secret/dependency scan; preview deployment. Required cross-lane review for shared contracts/schema. No merge with failed security or migration tests.

Branching is trunk-based with short-lived branches. Rebase before merge. One migration per PR with lane/module filename and rollback note. Preview environment uses synthetic data and separate credentials. Staging deploy follows merge; production release follows phase gate and manual founder review. Expand/contract schema path spans releases; feature flags gate incomplete P2/P3. Rollback application first; database rollback uses forward corrective migration, not destructive reverse in production.

Release checklist captures commit, migrations, flag changes, smoke tests, Sentry health, backups, and owner. Maintain a weekly integration checkpoint and release notes.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
