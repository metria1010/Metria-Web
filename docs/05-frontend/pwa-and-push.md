> Purpose: PWA and push behavior
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

# PWA and Push

Manifest has configurable product name, icons, theme and standalone display. Service worker caches static shell and public immutable assets only; never cache private marks, chat, bookings or API responses. Offline page explains connectivity and offers safe navigation; queued mutations are not silently replayed.

Web push is opt-in, HTTPS-only, VAPID-backed. Android supported; iOS only for installed PWA and compatible OS. Explain value before browser prompt. Shared permission coordinator serializes our prompt and any ad-network push request; our prompt takes priority, and if either is active the other waits. Respect denied permission and do not nag. Store subscriptions per device; revoke invalid endpoints. Email/in-app remain usable if push is unavailable.

Test install, update, offline public shell, private cache exclusion, permission grant/deny, token revocation and notification preference behavior on Android Chrome and current supported browsers. Native applications are out of scope; RPC contracts remain client-agnostic.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
