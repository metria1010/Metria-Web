> Purpose: Phase gates and evidence
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Milestones and Gates

| Phase | Gate | Required evidence |
|---|---|---|
| P0 Foundation | Both founders sign off | Repo/tooling/CI, local Supabase, auth tenant skeleton, RLS helpers, seeds, registry, test harness, business accounts, design tokens |
| P1 Launch | Both lanes pass | auth, academics/marks, booking base, objections, public SEO/legal/calculators, ads config/safety, admin basics, noindex/private boundary, commercial tiers/legal review, runbooks |
| P2 Expansion | Both lanes pass | messaging/coursework/calendar, social booking/waitlist, notification channels, visits/revenue/payouts, reviews/TA pages, tools/chatbot/share loops, moderation |
| P3 Delayed | Explicit enable review | free/busy, ephemeral eligibility, AI chatbot quota/tool boundary, teacher reviews last after legal review and feature flag |

Each phase must build/deploy, pass CI and critical Playwright flows, have migrations applied in staging, have flags correct, have monitoring and rollback paths. No feature is enabled solely because code is merged. P3 legal-risk modules require documented review.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
