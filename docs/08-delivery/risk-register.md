> Purpose: Security, business and delivery risks R1–R16
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Founder Risk Register

| ID | Risk | Mitigation and trigger | Owner |
|---|---|---|---|
| R1 | Third-party ads read private marks/DOM | isolation mode, tap reveal, CSP, per-page kill; trigger: unexpected request/DOM access | B |
| R2 | Aggressive ads harm SEO/trust | layer toggles, frequency caps, Safe Browsing/Search Console monitoring; trigger: security warning/rank anomaly | B |
| R3 | Auth ads look like phishing | zero scripts on auth enforced in code + DB test | B |
| R4 | Reviews create legal exposure | real anonymity, moderation/takedown, disclaimer, flag kill; teacher reviews launch last | B |
| R5 | Small cohorts reveal identity | k≥5, aggregate-only, no student breakdown | A/B |
| R6 | University-name/affiliation risk | disclaimer, no logos, configurable product name | B |
| R7 | Bot traffic/ad fraud | filtering, no raw IP, rate limits, no self-click policy, provider terms | B |
| R8 | Consent/legal noncompliance | consent gate, generated provider list, legal review | B |
| R9 | Free-tier/provider limits exceeded or free tier unsuitable | Stay within free-tier limits (DB size/egress/connections); monitor usage, optimize/archive before any capacity change; verify current free-tier terms | Shared |
| R10 | Marks altered incorrectly | append-only mark history, explicit CSV preview/confirm, staff RLS, audit | A |
| R11 | Two-founder bus factor | business-owned accounts, secrets inventory, runbooks, recovery drills | Shared |
| R12 | Payout disputes | immutable close, visible calculations, terms, compensating adjustments | B |
| R13 | Cross-tenant data leak | composite FKs, RLS tests, public allowlist audit | Shared |
| R14 | Queue loss/duplication | transactional outbox, dedupe keys, retry/DLQ and replay audit | A |
| R15 | Course/SEO data stale or thin | editorial review, source freshness, publication state, sitemap removal | B |
| R16 | AI prompt injection or cost abuse | server-side own-user context, tool allowlist, quotas, rate limits, P3 flag off | B |

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
