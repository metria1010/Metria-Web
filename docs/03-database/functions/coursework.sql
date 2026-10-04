> Purpose: RPC signatures and transaction boundaries
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

-- Security-definer RPCs must set search_path to empty, validate auth.uid(), verify tenant and role, and be granted narrowly.
-- Transactional module operations are defined as narrowly scoped RPCs in the API contract before UI consumers are implemented.
-- Rollback: revoke execute first; preserve append-only audit and financial history.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
