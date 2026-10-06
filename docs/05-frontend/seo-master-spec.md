> Purpose: Search rendering and indexation rules
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

# SEO Master Specification

Public pages are server rendered and usable without login. Index only substantial, original and published content. Private/auth routes use `noindex`; robots rules are not a privacy control. Canonical every indexable URL; strip tracking parameters; calculator state query URLs noindex and canonicalize to base. Do not index facets, thin duplicate course variations or private schedules.

Structured data must match visible content: Course, Person, Article, HowTo, FAQPage, BreadcrumbList, SoftwareApplication, WebSite/SearchAction. Validate with schema tests and Search Console. OG images are generated with a self-hosted renderer (e.g. Satori + resvg) and approved public data. Sitemap index split by content type, include stable lastmod and omit unpublished pages. Ensure 404/410 semantics and audited redirect entries.

Metadata templates and route render strategies are in route-map.md. Internal links form university/department/course/guide clusters. UGC links use `rel="ugc nofollow"`. Images are responsive and optimized; fonts subset and avoid layout shifts. JavaScript budgets prioritize public content; charts and ad scripts are deferred.

Technical goals: LCP <2.5s, INP <200ms, CLS <0.1 with ads on mid-range Android 4G. Collect consent-compliant RUM by route class; review Search Console coverage/security issues and Safe Browsing weekly.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
