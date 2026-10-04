> Purpose: Module reference seed
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

-- Foundation & Auth seed is idempotent and tenant-scoped. Insert controlled lookup rows with ON CONFLICT DO NOTHING. Never seed real personal data.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
