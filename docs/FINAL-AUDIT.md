> Purpose: Honest acceptance audit of the generated development-plan set
> Audience: founders and coding agents
> Prerequisites: `docs/TRACEABILITY.md`, `docs/SYMBOL_REGISTRY.md`, `docs/07-quality/test-strategy.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Final Audit

## Acceptance checklist

- [x] Every feature ID from G1–G9 and sections 1–14 is enumerated in `TRACEABILITY.md`; section 15 is excluded per brief.
- [x] The documentation tree includes product modules, architecture, database module files, backend, frontend, growth, quality, delivery, agent setup, and operations.
- [x] A symbol registry, decisions log, risk register including R1–R12, cost/tier guidance, runbooks, and Day 0 account checklist exist.
- [x] Documentation files have the required header, stay below 700 lines, and contain no TBD/omitted-for-brevity markers.
- [x] Tenant-owned schema tables include tenant keys and RLS enablement; root `universities` is treated as the tenant catalog.
- [x] Baseline RLS generated policies are restrictive (platform-admin-only) unless a narrower policy is explicitly added. This fails closed.
- [ ] Operation-specific student, TA, teacher, moderator, and service-role policies are not yet fully specified for every table. Add explicit SELECT/INSERT/UPDATE/DELETE policies and allowed/denied/cross-tenant pgTAP fixtures before implementing or using the database.
- [ ] Database test files currently assert table existence/RLS presence and selected invariants only. They do not yet provide the complete per-policy, cross-tenant, concurrency, import-idempotency, atomic swap, waitlist, objection rollback, or payout immutability suites required by the brief.
- [ ] Several transactional RPCs are contracts/examples rather than a complete production function set. Complete each function body, authorization path, grants, error model and transaction test before implementation.
- [ ] Not every foreign key in the generated SQL has a matching composite tenant FK and dedicated FK index. Perform the specified schema audit and correct each relationship before migration execution.
- [ ] Delivery cards are sequencing anchors and still need splitting into exact-path, independently deployable cards with concrete dependencies and per-phase lane estimates. Current ±15% balance is not demonstrated.
- [ ] The ad resolver is specified, but private-page isolation defaults, direct-SQL emergency procedure and policy/legal signoff require implementation-specific verification before ads are enabled.
- [ ] No database SQL was applied and no tests were run as part of generating this documentation.

## Required next engineering gate

Do not treat the SQL as ready to migrate. Before a coding lane starts database work, complete the schema audit: establish migration order, composite-FK and index coverage, operation-specific policies, policy-level pgTAP fixtures, and full transactional RPC bodies. Then run the required booking/import/swap/waitlist/objection/revenue invariants against local Supabase and record passing evidence here. Until those items pass, P1 student-data workflows and ad-enabled private pages are not ready for production.

## Registry delta

No symbols added by this audit file.

## Self-check

- [x] Passing and failing acceptance items are clearly distinguished.
- [x] SQL execution and test status are stated accurately.
- [x] Required remediation is identified before database implementation.
