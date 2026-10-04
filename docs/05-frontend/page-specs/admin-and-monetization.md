> Purpose: Route-group behavior and UI states
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A/B
> Last verified against SYMBOL_REGISTRY version: v1

# Page Specs

Admin screens manage universities/domains, roles, moderation, feature flags, ad networks, placements, sponsor creatives, kill switches, earnings, payouts and audit search. Every sensitive action requires confirmation, permission and audit event; payout allocation is immutable.

Every page has loading, empty, validation, permission-denied, unavailable and success states. Use responsive design and named analytics events without personal values.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
