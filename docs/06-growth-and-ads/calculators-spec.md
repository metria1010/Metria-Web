> Purpose: Formulae, boundaries and deterministic test cases
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

# Calculator Specifications

All calculators run locally; inputs are not sent to server. Show exact assumptions, units, rounding and a reset. Share links encode only non-sensitive inputs; result-state query URLs are noindex and canonical base.

| Calculator | Formula | Edge handling | Test vectors |
|---|---|---|---|
| GPA/CGPA | GPA = Σ(grade points × credit hours)/Σ attempted credit hours; CGPA applies configured repeat/withdrawal policy | zero credits => validation; incomplete/withdrawn excluded only by selected policy; cap displayed points to scale | (4.0×3 + 3.0×1)/4 = 3.75; empty credits => error |
| FAST-style absolute/relative grade | absolute: find configured score band; relative: compute class distribution and apply explicit configured thresholds | no cohort => unavailable; cohort < k => suppress class-derived output; no hidden student rows | score 85 in [80,100] A => A; k-1 cohort => suppressed |
| Final marks needed | required final score = (target weighted points − current earned weighted points)/final weight; convert to raw marks using final total | weight ≤0 error; target already met => 0; required > total => impossible; missing assessments explicit | current 40, target 70, final weight .4 => 75% of course score; beyond final total => impossible |
| Attendance | attendance % = attended/held×100; max future absences preserving threshold = floor(attended/threshold − held) after adding current counts | held=0 undefined; threshold 0–100; future schedule optionally included | 18/20=90%; threshold 80 => max 2 additional misses if no extra classes held |

Relative grading inputs must specify policy and use no identity-level data. Unit tests cover boundaries, rounding half-up, negative/over-total, missing values, zero denominator, malformed scale and localized number formats. Long-tail SEO pages explain policy, not claim institution endorsement.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
