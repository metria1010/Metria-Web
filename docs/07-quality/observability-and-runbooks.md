> Purpose: Telemetry and operational procedures
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Observability and Runbooks

Structured logs include timestamp, level, environment, request/correlation ID, route template, event code, tenant UUID where permitted and duration. Exclude tokens, email, roll number, marks, message body and payout account. Sentry captures frontend and Edge exceptions with scrubbers. Uptime probes public home, auth callback health, and a safe database health endpoint.

Alerts: auth error rate; booking RPC conflict/error anomaly; DB p95/connection/storage; outbox oldest age/DLQ volume; ad CSP violations and malicious redirect reports; CWV regressions; backups/partition job failures; payout reconciliation mismatch. Weekly review slow queries and RLS regressions. Quarterly restore drill.

Runbooks: `login-down.md`, `ad-network-misbehaving.md`, `database-capacity-or-outage.md`, `email-provider-down.md`, `restore-drill.md`. Each states severity, detection, immediate containment, evidence, recovery, verification, and post-incident action.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
