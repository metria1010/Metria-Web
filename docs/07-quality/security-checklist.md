> Purpose: Security verification checklist
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Prelaunch Security Checklist

- [ ] RLS enabled and forced on all tables; grants/policies independently reviewed.
- [ ] Cross-tenant read/write pgTAP tests pass for every module.
- [ ] Public views use explicit allowlisted columns and publication filters.
- [ ] Auth-domain hook server-enforced; bootstrap admin audited and one-time.
- [ ] Service role absent from browser bundle and logs.
- [ ] Zod on all server inputs; rate limits cover writes, auth, chat, reports, links and AI.
- [ ] CSP Report-Only reviewed then enforcement staged; auth pages load zero ad scripts.
- [ ] Consent gates all ad/analytics scripts as policy requires.
- [ ] Rich-text XSS, malicious URL, SSRF and link-only rules tested.
- [ ] Marks/history/audit atomic; payouts and allocations immutable.
- [ ] Calendar tokens hashed, revocable and owner-scoped.
- [ ] Transcript parser has verified zero network requests and no persistent storage.
- [ ] Backup/PITR enabled, restore drill completed, secrets inventory verified.
- [ ] Provider terms, commercial service tiers, privacy/legal terms reviewed at execution time.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
