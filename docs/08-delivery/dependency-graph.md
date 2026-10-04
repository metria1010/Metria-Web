> Purpose: Card DAG and interface dependencies
> Audience: founders and coding agents
> Prerequisites: `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Card Dependency Graph

```mermaid
graph TD
S[T-S001 Foundation Gate] --> A2[T-A002 Auth]
S --> B1[T-B001 Public foundation]
A2 --> A3[T-A003 Academic catalog]
A3 --> A4[T-A004 Marks and CSV]
A3 --> A6[T-A006 Booking]
A4 --> A8[T-A008 Objections]
A6 --> A7[T-A007 Social booking]
S --> B2[T-B002 Ads config]
B1 --> B4[T-B004 SEO calculators]
B2 --> B3[T-B003 Sponsors/isolation]
B1 --> B5[T-B005 Visits]
B5 --> B6[T-B006 Revenue/payouts]
A2 --> A9[T-A009 Messaging]
A3 --> A10[T-A010 Coursework]
A2 --> A11[T-A011 Calendar]
A11 --> A13[T-A013 Free/busy]
B1 --> B7[T-B007 TA profile/reviews]
B7 --> B12[T-B012 Teacher reviews last]
```

Cross-lane interfaces: A supplies university/membership, course/offering/staff contracts before B public tenant/course pages and revenue attribution. B supplies publication views, ad resolver and consent contracts before A page layouts. Both use shared audit/outbox/feature flag contracts. Mock interfaces land before consumer UI. Integration checkpoint each week; if contract changes, version DTO and preserve previous consumer compatibility.

The two founder lanes have roughly comparable P1 effort only after shared foundation is excluded; P2/P3 estimates must be rebalanced by splitting cards and moving interface-owned screens. The included principal cards are sequencing anchors and remain intentionally split during execution; they are not a reliable final per-phase ±15% estimate.

## Self-check
- [x] Header and required content are present.
- [x] Naming source and ownership are stated.
