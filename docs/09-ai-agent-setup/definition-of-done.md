> Purpose: Shared completion checklist
> Audience: founders and coding agents
> Prerequisites: `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Definition of Done

- Acceptance criteria pass and changes match card scope.
- Zod/server validation, authorization and RLS behavior are verified.
- Unit/integration/pgTAP/Playwright coverage appropriate to the contract is added and run.
- Migration is clean-apply tested, tenant-safe, indexed, documented and reversible by forward migration.
- Accessibility, mobile, loading/error/empty states are handled.
- Public SEO/ad rules, consent, noindex or privacy controls are covered.
- Logs exclude sensitive values; audit/outbox/idempotency requirements hold.
- Registry, traceability and migration plan match actual symbols.
- CI green; peer/cross-lane review complete; rollout flag and recovery path documented.

## Self-check
- [x] Header and required content are present.
- [x] Naming source and ownership are stated.
