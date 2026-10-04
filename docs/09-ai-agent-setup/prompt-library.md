> Purpose: Agent session prompts
> Audience: founders and coding agents
> Prerequisites: `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Reusable Agent Prompts

## Start a card
Read `docs/09-ai-agent-setup/AGENTS.md`, the assigned card, and only its listed context. Confirm dependencies and registry symbols. Implement the card scope, tests, and documentation delta. Do not broaden scope.

## Review a change
Review the diff against its task card, locked decisions, registry, security boundaries, migrations, tests, accessibility, SEO/ads, and rollback path. Report actionable findings with file/line and severity; do not modify files unless asked.

## Debug a failure
Reproduce the named failure using synthetic fixtures. Identify root cause before editing. Add a regression test, implement the smallest fix within card scope, rerun relevant checks, and report exact evidence.

## Migration/RLS review
Check clean apply, migration ordering, tenant NOT NULL, composite parent FK, FK/filter indexes, trigger, RLS enabled/forced, least privilege per operation, cross-tenant tests, public view exposure, expand/contract and rollback note. Reject any table without policy tests.

## Refactor
Preserve observable contract, registry names, data semantics and tests. Avoid behavior changes. Document any required symbol change before applying it.

## Self-check
- [x] Header and required content are present.
- [x] Naming source and ownership are stated.
