> Purpose: Core architecture and execution specification
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Notification Engine

Events enter `notification_events` with stable dedupe key, recipient, event type and minimal payload. A resolver checks per-user preferences, quiet hours, tenant policy, consent/channel support, and event urgency, then creates one `notification_deliveries` row per allowed channel. Templates are locale-keyed through next-intl, escaped, and contain unsubscribe/preferences links for email.

Channels: in-app, email via Resend adapter, web push via VAPID. Delivery attempts record status, provider message ID, timestamps and safe error code; secrets and message bodies are not logged. Exponential retry with jitter, max five attempts, then DLQ. Admin replay checks current consent/preferences before dispatch. Dedupe key examples: `booking-reminder:<booking-id>:<offset>`, `objection-status:<objection-id>:<status-version>`.

User controls channel, category, quiet hours, and digest. Security notices cannot be fully disabled but are minimized. Unsubscribe token is scoped, signed, revocable, and changes email preferences only. Push subscriptions are per device and revoked on provider 404/410. One prompt coordinator serializes our push-permission UI and any ad network prompt; our notification explanation has priority.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
