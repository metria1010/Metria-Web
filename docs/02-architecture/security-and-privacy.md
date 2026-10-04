> Purpose: Core architecture and execution specification
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Security and Privacy Architecture

## Authorization
RLS is enabled and forced on every table, default deny. Private helper functions live in `private`, set `search_path=''`, and validate `auth.uid()`. Composite `(university_id,id)` foreign keys prevent cross-tenant references. Service role is never shipped to browser. Every route mutation validates session, tenant, permission and Zod payload server-side.

## Public/private boundary
Anonymous reads go only through whitelisted `public_*` views/functions with explicit column lists and publication state. Private tables have no anon grants. No view exposes a student identifier, mark, transcript, message, objection, or booking identity. Aggregates suppress cohorts below k=5; rank is anonymous. TA profile/public links require opt-in.

## Sensitive data
Marks and payout account identifiers are restricted to necessary roles; payout reference is ciphertext and access logged. Transcript eligibility parsing stays in browser memory, disables telemetry on file selection, and never uploads contents. Calendar token stores only a hash, is revocable, and yields owner-only events. Delete requests follow the lifecycle matrix while retaining legally required immutable financial/audit records in minimized form.

## Ads and content security
Consent is checked before ad scripts. Auth routes enforce no script and DB config constraint. CSP starts Report-Only, collects sanitized reports, then moves to enforced with allowlisted providers. Use `frame-src`/`script-src` allowlists, `Permissions-Policy`, strict referrer policy, iframe sandbox where supported, and no inline arbitrary network code. On private marks pages tap-to-reveal sensitive values; per-page `isolation_mode` can switch to iframe-only or no-script with one action.

## Abuse controls
Rate-limit auth-adjacent requests, writes, reports, chat, URL submissions and future AI. Reject file uploads except ephemeral local parsing; link submissions allow only http/https and block private-network/loopback targets during server-side link checks. Escape and sanitize rich text. Report/block/mute flows are auditable.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
