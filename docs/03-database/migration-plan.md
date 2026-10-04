> Purpose: Core architecture and execution specification
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Migration Plan and Ownership

1. `s_foundation`: extensions, private schema, universities/domains/profiles/membership, role catalog, flags, helper functions, auth hook.
2. `a_academics`: academic structure, assessments, marks/history, imports and announcement base.
3. `a_booking`: periods, slots, bookings, exclusion/unique constraints, transactional RPC.
4. `a_objections`: objection thread and atomic mark-change RPC.
5. `b_public_ads`: publication tables/views, page/ad registries, consent and kill switches.
6. `a_coursework_messaging`: coursework, messages and moderation.
7. `a_calendar_notifications`: timetable, calendar tokens, outbox and delivery.
8. `b_revenue_reviews`: reviews, visit aggregation, immutable revenue and payout ledger.
9. `b_admin_chatbot`: admin, help, AI usage and deletion controls.

Use actual timestamp names `<UTC timestamp>_s|a|b_{{module}}_<slug>.sql`; one migration per PR. Announce table/contract changes in the shared channel before coding consumers. Rebase before merge; migration CI checks clean apply and pgTAP. Lane owner reviews own schema; other lane reviews shared boundaries. Rollback note is required in each migration. Expand/contract: add compatible nullable field/table, deploy dual-compatible code, backfill, verify, switch reads, then drop obsolete field in a later release. No production dashboard edits or destructive single-release rename/drop.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
