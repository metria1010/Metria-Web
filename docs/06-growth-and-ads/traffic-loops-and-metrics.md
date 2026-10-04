> Purpose: Growth loop mechanics and measurement
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

# Traffic Loops and Metrics

| Loop | Flag | Trigger and action | Metric / privacy |
|---|---|---|---|
| Share calculator result | `sharing.enabled` | copy/WhatsApp link to base calculator plus non-sensitive parameters | share rate, completion; no personal inputs |
| TA invite link | `sharing.enabled` | TA invites verified staff; expiring single-use link | invite acceptance; hashed token |
| Public guide/course internal links | public content flag | related course and guide links | organic pages/session |
| Booking/calendar reminder | `notifications.push.enabled` | user-selected email/in-app/push reminder | on-time attendance; preference respected |
| Marks/announcement return visit | notification preference | alert when own marks posted or section announcement published | return visits; no content in analytics |
| WhatsApp schedule share | sharing flag + P2 public schedule | share sanitized public schedule/open counts | share clicks; never names/booking data |

Dashboard: organic sessions, indexed pages, pages/session, returning visitors, calculator completions, signup conversion, booking completion, ad RPM by page type, viewability, consent and CWV. Prevent self-click with QA accounts, provider test creatives, and written no-click policy.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
