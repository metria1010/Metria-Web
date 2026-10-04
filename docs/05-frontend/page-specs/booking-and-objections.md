> Purpose: Route-group behavior and UI states
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A/B
> Last verified against SYMBOL_REGISTRY version: v1

# Page Specs

Period detail shows available slot counts only to authorized student; booking uses atomic RPC, confirmation and cancellation cutoff. TA view lists students only to offering staff. Objection form includes reason and optional HTTPS link; thread state is open/under_review/resolved/rejected; mark change only through atomic objection RPC.

Every page has loading, empty, validation, permission-denied, unavailable and success states. Use responsive design and named analytics events without personal values.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
