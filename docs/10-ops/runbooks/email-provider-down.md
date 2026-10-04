> Purpose: Critical incident response
> Audience: founders and coding agents
> Prerequisites: `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Email Provider Down Runbook

Check Resend status, domain verification and quotas. Leave queued notifications in outbox; in-app delivery remains active. Confirm bounded retries/backoff and DLQ. Do not resend by bypassing dedupe. After recovery, replay eligible DLQ through admin permission and audit; honor current user preferences and unsubscribe state. Verify SPF/DKIM/DMARC and sample delivery.

## Self-check
- [x] Header and required content are present.
- [x] Naming source and ownership are stated.
