> Purpose: Core architecture and execution specification
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Stack and Version Policy

| Area | Decision | Version policy |
|---|---|---|
| Runtime | Node LTS, pnpm | Pin Node major in toolchain file; lock dependencies |
| Web | Next.js App Router, TypeScript strict | Pin current stable at Phase 0; upgrade quarterly after CI |
| UI | Tailwind, shadcn/ui, next-intl | Pin compatible versions |
| Data | Supabase JS, generated DB types | Generate from local migration state; no ORM |
| Database | Supabase Postgres, CLI migrations | CLI pinned; migrations are sole schema source |
| Validation | Zod | Shared schemas across route handlers and clients |
| Tests | Vitest, Playwright, pgTAP | CI-required |
| Email/errors/charts/editor | Resend adapter, Sentry, Recharts lazy, Tiptap | Provider adapter and sanitization tests |

Exact point releases are deliberately recorded in the Phase 0 lockfile because versions change; the implementation card must verify current stable releases and compatibility before pinning. Do not copy stale versions from this plan. Rejected alternatives: ORM migrations (conflict with locked SQL-first rule), microservices (team size and modular monolith decision), direct provider calls from UI (secret and retry boundary), client-authoritative authorization (unsafe).

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
