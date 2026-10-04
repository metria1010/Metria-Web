> Purpose: UI tokens, accessibility and states
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Design System

Use Tailwind tokens for semantic color, spacing, typography, radius, elevation and z-index. Product name comes from `NEXT_PUBLIC_PRODUCT_NAME`/`platform_settings`; never hard-code Metria or Assessia in reusable UI. shadcn primitives provide buttons, fields, dialog, menu, tabs, table, toast, skeleton and alert. Keep academic data tables keyboard-operable with mobile card fallback.

Mobile-first breakpoints: 360 px baseline; no horizontal page scroll; persistent bottom navigation for core student flows and compact desktop sidebar. Use readable contrast, visible focus, labels, screen-reader names, reduced motion, keyboard operability and WCAG 2.1 AA. Do not convey status by color alone.

Global states: skeleton while loading; specific empty-state action; inline retry for recoverable errors; full error boundary with correlation ID; offline shell explains cached content age and blocks unsafe mutation. Sensitive mark values may be hidden until user taps reveal. Ads reserve exact aspect ratio and spacing tokens; never overlap or sit adjacent to Book/Submit/Objection actions.

English strings go through next-intl message catalogs. Dates display in university timezone, currency in explicit ISO code. Forms use shared Zod schemas and server errors.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
