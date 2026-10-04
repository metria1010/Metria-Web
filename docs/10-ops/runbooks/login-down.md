> Purpose: Critical incident response
> Audience: founders and coding agents
> Prerequisites: `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Login Down Runbook

Confirm uptime and Supabase Auth status. Determine affected OAuth callback/domain hook. Disable new sign-in banner only if needed; never bypass domain validation. Check redirect allowlist, Google OAuth secret expiry, auth hook logs and clock. Roll back last auth deployment if correlated. Verify allowed and denied domains in staging, then production test account. Record incident and rotate exposed credentials.

## Self-check
- [x] Header and required content are present.
- [x] Naming source and ownership are stated.
