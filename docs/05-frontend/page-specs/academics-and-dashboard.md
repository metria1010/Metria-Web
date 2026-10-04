> Purpose: Route-group behavior and UI states
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A/B
> Last verified against SYMBOL_REGISTRY version: v1

# Page Specs

Student dashboard combines upcoming evaluation, own bookings, latest own marks and announcements in one bounded RPC. Marks page shows only caller’s marks; class statistics/rank are privacy-thresholded, rank anonymous. TA analytics restrict to staffed offerings. Empty states explain no sections/marks and link next action.

Every page has loading, empty, validation, permission-denied, unavailable and success states. Use responsive design and named analytics events without personal values.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
