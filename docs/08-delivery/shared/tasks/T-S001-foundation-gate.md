> Purpose: Joint foundation gate
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# T-S001 Foundation Gate

Phase: P0 Lane: Shared Size: L (7–8 hours, split between founders)
Depends on: none Blocks: all lane cards Feature IDs: G1-G9

## Goal
Establish deployable repo, local Supabase, migration/test workflow, shared type generation, CI, business-owned account inventory and baseline RLS/auth contracts.

## Context to load
`docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`, `docs/03-database/conventions.md`, `docs/08-delivery/lanes-and-ownership.md`.

## Scope
Create root tooling/config, CI workflow, Supabase config/migrations, `.env.example`, minimal app shell, `CODEOWNERS`, test fixtures and generated types. Do not build feature modules.

## Steps
1. Pin current Node LTS and compatible package versions in lockfile.
2. Configure strict TS, lint/format, Husky, local Supabase, Vitest/Playwright/pgTAP.
3. Add environment validation and ensure service role is server-only.
4. Add CI clean migration apply, typecheck, tests and build.
5. Add two-tenant synthetic fixtures and baseline auth/RLS helper.
6. Record account owners and secrets in Day 0 checklist.

## Acceptance / tests
Given a clean clone, when documented setup is followed, then install, local DB migration, tests and production build succeed. CI rejects an exposed service key and a migration without lane prefix.

## Security, SEO, ads
RLS default deny, no public private-table grants; `/auth/*` noindex and zero ad scripts.

## Definition of Done
- [ ] CI green on clean clone.
- [ ] Both founders can restore environment from documented secrets inventory.
- [ ] Foundation Gate signed by both lanes.

## Stop triggers
Ask only for secrets that cannot be provisioned from business-owned accounts; never commit them.

## Agent prompt
```text
Implement T-S001 using linked docs. Build the smallest deployable foundation, verify clean setup and CI, keep secrets out of source, and report reproducible commands and evidence.
```

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
