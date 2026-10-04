> Purpose: Core architecture and execution specification
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Data Lifecycle

| Data | Retention and disposition |
|---|---|
| Marks and mark history | Retain during university relationship and policy period; deletion request anonymizes where permitted and preserves audit evidence |
| Audit and role history | Immutable; minimize personal payload, retain per legal/accounting schedule |
| Raw page visits | Partition monthly, drop after 90 days; aggregates kept without persistent visitor identifiers |
| Messages | 180-day default; configurable university retention and moderation hold |
| Calendar tokens | Revoke on request, expiry or account removal; retain hash only while active |
| Push endpoints | Delete on unsubscribe, invalid endpoint or account deletion |
| Imports | Preview expires; source rows purge after 30 days; retain batch counts and audit only |
| Consent | Retain policy version, categories and decision timestamp for proof; remove direct identifiers when no longer needed |
| Payout records | Keep immutable amounts/events per accounting and dispute terms; restrict identifiers |
| Transcript/timetable eligibility inputs | Browser-memory only; never upload or persist |

Deletion flow verifies requester, opens `data_deletion_requests`, previews affected categories, processes table-specific delete/anonymize rules, writes immutable completion audit, and returns status. Legal holds suspend only affected records with reason and reviewer. Monthly partition job creates future partition before ingest and alerts on failure.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
