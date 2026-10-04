> Purpose: Rules for all repository coding agents
> Audience: founders and coding agents
> Prerequisites: `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Coding Agent Master Rules

1. Read `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`, the module contract and assigned task card before editing.
2. Implement only the card scope. Keep each change deployable, update tests and report evidence.
3. SQL migration is the schema authority; no dashboard edits or ORM. Use registry names exactly. New names require a registry delta first.
4. Enforce auth, tenant and role at server and database. Assume UI is bypassable. RLS is default-deny. Never expose service role or log student data.
5. All server boundaries validate with Zod. Retryable operations need idempotency. Sensitive mutations write append-only history/audit.
6. Public reads use only whitelisted `public_*` views/functions. Never publish student data. Auth pages have no ad code.
7. Follow expand/contract, tenant composite FKs, UTC timestamps and integer minor units. One migration per PR; lane prefix; rollback note.
8. Add named unit, pgTAP, integration and Playwright tests. Include allowed, denied and cross-tenant policy cases. Do not claim tests passed unless executed.
9. Use product name config; English UI strings via next-intl; meet WCAG 2.1 AA and mobile layout.
10. Stop for unavailable secrets, legal decisions or conflict with locked architecture; otherwise follow DECISIONS defaults. Never invent a provider integration or permission.
11. Every public route documents canonical, metadata, structured data, publication state and ad policy. Every ad slot reserves geometry and fails empty.
12. PR summary includes files, behavior, commands/results, migrations, registry delta, risks and next card.

## Self-check
- [x] Header and required content are present.
- [x] Naming source and ownership are stated.
