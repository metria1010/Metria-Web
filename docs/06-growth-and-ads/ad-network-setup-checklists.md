> Purpose: Provider setup and ad safety checks
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

# Network Setup and QA

## Adsterra initial setup
Business account under company identity; verify publisher/domain ownership; configure adult, gambling, dating and VPN blocks; disable any unsupported unsafe format; document allowed script hosts and account owner; add only approved placement IDs to secret/config registry; verify consent behavior and kill switch in staging.

## Subsequent network onboarding
For Monetag or another approved provider, repeat domain/account ownership, terms review, category blocks, format inventory, script host review, privacy-policy listing, placement config, consent test, CSP report, mobile and low-bandwidth QA, screenshot evidence, and kill-switch drill. AdSense remains out of scope.

## Recurring QA
Weekly inspect representative public and private pages on mobile and desktop with consent granted/denied. Capture screenshots, check redirects/popups, malvertising, action-button spacing, auth exclusion, CLS, console/CSP errors, and policy compliance. Never click production ads; use provider preview/test creatives. Check Search Console Security Issues and Google Safe Browsing status. Report bad creative to provider and trigger network kill switch immediately. Maintain incident timestamp, affected network, evidence URL, and recovery verification.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
