> Purpose: Core architecture and execution specification
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Repository Structure and Conventions

```text
src/app/                 route composition only
src/features/{{module}}/   owned feature UI, actions, schemas
src/lib/supabase/        clients and generated database types
src/lib/security/        auth, rate limit and validation utilities
src/components/ui/       shared shadcn primitives
supabase/migrations/     timestamp_lane_module_slug.sql
supabase/functions/     Edge Functions and _shared contracts
docs/                    canonical product and engineering plan
````

Use `a_` or `b_` in migration filename after timestamp; shared migrations use `s_`. One migration per PR. Module owner writes migration; other founder reviews shared constraints/RLS. Never edit remote dashboard schema. Generated type changes are committed with migration. CODEOWNERS protects `/src/features/academic/` and `/src/features/booking/` for A; `/src/features/growth/`, `/src/features/ads/`, `/src/features/admin/` for B; shared libraries, migrations, and contracts require one owner plus other-lane review.

Names: SQL snake_case; TypeScript camelCase; React components PascalCase; feature flags and permissions match registry exactly. Errors use stable codes and safe messages; logs include correlation ID and omit personal academic content. Use UTC in persistence and explicit university timezone for presentation.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
