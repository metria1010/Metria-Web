> Purpose: Route-group behavior and UI states
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A/B
> Last verified against SYMBOL_REGISTRY version: v1

# Page Specs

TA profile requires opt-in per field and public publication; review author identity is held separately under restricted RLS; public output is aggregate only at threshold. Invite links are hashed, scoped, expiring, single-use and revocable. Eligibility parser remains entirely in browser memory.

Every page has loading, empty, validation, permission-denied, unavailable and success states. Use responsive design and named analytics events without personal values.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
