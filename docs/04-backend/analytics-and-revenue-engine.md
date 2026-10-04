> Purpose: Revenue calculation and ledger
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

> Purpose: Core architecture and execution specification
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Analytics and Revenue Engine

## Visit attribution
Ingest only allowlisted route/page identifiers after consent where required. Do not store raw IP, full user agent, email, or permanent visitor ID. Use a daily rotating salted hash and bot filters; aggregate raw partitions daily, retain raw 90 days. Attribution rules are versioned by effective date: TA public profile → that TA; authored public guide → credited author; public course catalog → platform unless explicit offering staff rule is published; private section page → staff pool under disclosed rule; calculators/tools/home/legal → platform. Shared pages split only by documented rule.

## Revenue close
Admin enters actual network earnings with currency, month, FX-to-PKR source/rate, statement reference and idempotency key. Convert to integer PKR minor units using recorded rate and documented rounding (half-up at minor unit); reconcile total to statement. Percentage model defaults to 5,000 basis points of attributable net actual earnings. Example: attributable PKR 10,000.00 = 1,000,000 minor units; TA pool 500,000; platform 500,000. If two TAs have equal eligible visits, allocate 250,000 minor units each and platform retains 500,000. Remainder minor units go to platform; snapshot all inputs/model version.

Monthly close inserts immutable `revenue_allocations` once. Corrections create signed adjustment entries with reason and reference; never update old allocation. Payout requests require verified payout account, minimum PKR 2,000 (200,000 paisa), dual-step review and status event. Bank/JazzCash/Easypaisa references are sensitive. Payout event/audit rows are append-only.

Test vector: actual earnings 1,000,000 paisa; 50% TA pool; attribution weights 60/40; allocation = TA1 300,000, TA2 200,000, platform 500,000. Sum must equal source amount exactly. Payout 199,999 paisa is ineligible; 200,000 is eligible.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.

## Attribution integrity
Do not credit a TA based on client-submitted attribution. Resolve entity and staff assignment on server using versioned rules; store rule version with aggregate. Filter known crawlers, data-center bursts and repeated impressions. A network statement amount is not inferred from visits: visits determine attribution weights only. Monthly allocation must reconcile exactly to actual recognized earnings after explicit rounding.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
