> Purpose: Minimal per-task context inventory
> Audience: founders and coding agents
> Prerequisites: `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Context Packs

| Work | Required files |
|---|---|
| Any card | `AGENTS.md`, assigned card, `DECISIONS.md`, `SYMBOL_REGISTRY.md` |
| Database | above + `03-database/conventions.md`, module schema/RLS/function/test files, migration plan |
| Academic UI | academic module spec, route map, academic page spec, API contract |
| Booking | booking module, schema/RLS/functions/tests, booking page specs, notification engine |
| Public/SEO | public module, route map, SEO master spec, content plan, security/privacy |
| Ads | monetization module, ad system, provider checklist, risk register R1-R3/R7-R8 |
| Revenue | revenue engine, schema/functions/tests, risk register R12 |
| Operations | relevant runbook, failure modes, capacity plan, day0 secrets inventory |

Load no unrelated task histories. Generated DB types are included only after their migration dependency is merged.

## Self-check
- [x] Header and required content are present.
- [x] Naming source and ownership are stated.
