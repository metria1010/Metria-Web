> Purpose: Atomic executable task card
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Lane B
> Last verified against SYMBOL_REGISTRY version: v1

# T-B003 Direct sponsors and ad isolation

Phase: P1  Lane: Lane B  Size: M (4–7 hours)
Depends on: Shared Foundation Gate and preceding contract cards. Blocks: corresponding module integration card. Feature IDs: 10.5,R1,R2,R3.

## Goal
Deliver the named module increment behind its feature flag, preserving a deployable application and the contracts in the registry.

## Context to load
docs/06-growth-and-ads/ad-system-spec.md; docs/07-quality/security-checklist.md
Also load `docs/09-ai-agent-setup/AGENTS.md`, `docs/DECISIONS.md`, and `docs/SYMBOL_REGISTRY.md`.

## Scope — files to create/modify
Implement only the owning `src/features/{module}/` files, exact migration for the registered module, generated DB types, and tests. Do not edit another lane's feature directory, public contracts, or registry without review.

## Detailed steps
1. Confirm dependencies are merged and feature flag defaults correctly.
2. Read the schema/RLS/RPC and route/page contract before implementation.
3. Add Zod input/output contracts and typed service boundary.
4. Implement minimal accessible UI and server-side authorization.
5. Add audit/outbox/analytics hooks specified for the module.
6. Run unit, pgTAP, integration and targeted Playwright checks.
7. Update registry/traceability if any symbol changes and request cross-lane review.

## Data/contract changes
Use existing registered tables and signatures. A new symbol requires registry delta first and migration filename `<timestamp>_{lane}_{module}_<slug>.sql`; migration must include rollback note and expand/contract plan.

## Acceptance criteria
- Given an authorized user, when they perform the flow, then the documented success state is persisted exactly once.
- Given missing role, tenant mismatch or invalid input, when the same request is attempted, then it fails closed with a stable safe error and no side effect.
- Given retry, timeout or provider failure, when the request is repeated, then idempotency and outbox policy prevent duplicate business state.
- Given mobile viewport and keyboard-only use, when the page is operated, then all controls remain usable and status is announced accessibly.

## Tests to write
Vitest `{module}.validation.test.ts`; pgTAP `{module}.rls.test.sql` allow/deny/cross-tenant; Playwright `{module}.journey.spec.ts`; add race/idempotency test for booking/import/ledger flows.

## Security & RLS checks
Verify server session, active membership, role and tenant from trusted state. Never trust UI checks. Assert direct unauthorized table writes fail; service role never reaches browser; logs exclude student information.

## SEO / Ads / Analytics hooks
Public content follows canonical/publication rules and reads only public views. Private pages are noindex. Resolve configured ad slots with consent and reserved dimensions; auth has none. Emit allowlisted analytics fields only.

## Definition of Done
- [ ] CI and module tests pass.
- [ ] Migration applies on empty local DB and policy tests pass.
- [ ] Feature flag and rollback path are verified.
- [ ] Registry/traceability and docs are updated.
- [ ] Cross-lane contract review completed.

## Stop and ask the human triggers
Stop for unavailable production secrets, a legally binding policy decision, or a contradiction with a locked decision; otherwise apply documented defaults.

## Agent prompt
```text
Implement T-B003 Direct sponsors and ad isolation. Read only the linked context and the master agent rules. Follow SYMBOL_REGISTRY names exactly. Keep tenant/RLS checks server-side, add the named tests, do not expand scope, run CI checks, and report files changed, test evidence, risks, and registry delta.
```

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
