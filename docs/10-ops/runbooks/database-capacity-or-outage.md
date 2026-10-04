> Purpose: Critical incident response
> Audience: founders and coding agents
> Prerequisites: `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Database Capacity or Outage Runbook

Check provider status, connection pool, storage, egress and slow-query dashboard. Pause noncritical aggregation jobs; do not disable RLS or remove constraints. Preserve queue and incoming requests. Scale paid tier/compute if threshold crossed. Validate backup/PITR point before recovery. Run health checks, booking/import atomicity smoke tests and cross-tenant check after service returns. Record mitigation and follow-up index/query work.

## Self-check
- [x] Header and required content are present.
- [x] Naming source and ownership are stated.
