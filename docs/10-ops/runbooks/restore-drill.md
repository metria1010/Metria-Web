> Purpose: Critical incident response
> Audience: founders and coding agents
> Prerequisites: `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Restore Drill Runbook

Quarterly restore a production backup/PITR snapshot into an isolated recovery project. Restrict access and use synthetic validation. Record restore point, duration, schema version and data loss window. Verify login-independent DB health, table counts, RLS policies, indexes, key RPCs, outbox integrity and immutable ledger sums. Do not route traffic until both founders approve. Delete isolated restore securely after signoff and update recovery time/objectives.

## Self-check
- [x] Header and required content are present.
- [x] Naming source and ownership are stated.
