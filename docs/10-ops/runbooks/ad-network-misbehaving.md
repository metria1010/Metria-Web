> Purpose: Critical incident response
> Audience: founders and coding agents
> Prerequisites: `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Ad Network Misbehavior Runbook

Immediately activate per-network kill switch; if uncertain use global kill. If dashboard is unavailable, use documented restricted SQL path to set `ad_kill_switches.enabled=false`, with second-founder review and audit insertion. Switch affected page types to no-script isolation. Capture URL/screenshot/time/network/creative ID without clicking the ad. Check CSP reports, Search Console Security Issues and Safe Browsing. Notify provider via business account. Re-enable only after provider confirmation and staging verification.

## Self-check
- [x] Header and required content are present.
- [x] Naming source and ownership are stated.
