> Purpose: Complete route, rendering, SEO and ad matrix
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

# Route Map

| Route pattern | Access/render | Index/canonical | Structured data / metadata | Ad policy | Owner |
|---|---|---|---|---|---|
| `/` | public ISR | index, self canonical | WebSite + SearchAction | configured public slots | B |
| `/about`, `/contact`, `/legal/*` | public ISR | index, self canonical | Organization/BreadcrumbList as appropriate | configured; legal consent | B |
| `/universities/[slug]` | published public ISR | index only active published tenant | CollegeOrUniversity only with factual metadata | public config | B |
| `/universities/[slug]/departments/[department]` | public ISR | index; canonical path | BreadcrumbList | public config | B |
| `/courses/[course]` | published public ISR | index, canonical catalog slug | Course + BreadcrumbList | public config | B |
| `/ta/[handle]` | explicit opt-in ISR | index only while published | Person + BreadcrumbList | public config | B |
| `/guides/[slug]`, `/blog/[slug]` | published ISR | index; UGC links rel ugc nofollow | HowTo/Article/FAQ only if matching content | public config | B |
| `/help/[slug]` | published ISR | index, self canonical | FAQPage only when visible Q/A | public config | B |
| `/calculators/[calculator]` | public SSG/ISR | base URL index; query results noindex canonical base | SoftwareApplication + BreadcrumbList | public config | B |
| `/tools/[tool]` | public SSG | index landing; user data local only | SoftwareApplication | public config | B |
| `/auth/*` | auth SSR | noindex, no canonical indexing | none | hard disabled in code and DB | A |
| `/app/*` | authenticated SSR | noindex, no public cache | none | configured private formats; no ad data in DOM; auth still required | A |
| `/admin/*` | platform admin SSR | noindex | none | off by default, can only enable approved safe format | B |
| `/api/*` | server endpoint | noindex, no page rendering | none | none | owning lane |

Titles: `{Course code} {Course title} at {University} | {NEXT_PUBLIC_PRODUCT_NAME}`. Description: factual, unique, ≤160 characters. TA pages use opted-in name and approved fields. OG images generated with @vercel/og from sanitized public fields, no logos without rights. Sitemap index split by universities, courses, TAs, guides, and articles; include lastmod from publication update. Robots disallows `/app/`, `/admin/`, `/auth/`, API and parameterized state URLs. 404 for absent drafts, 410 for intentionally removed URLs; redirect table only for verified moves. Pagination has self-canonical page URLs and crawlable links.

Internal links connect university → department → course → published guides; TA profile links only to opted-in offerings; calculators cross-link relevant explanatory guides. CWV: LCP <2.5s, INP <200ms, CLS <0.1 including ads on mid-range Android 4G. Reserve ad dimensions, lazy-load below fold, optimize fonts/images, collect consent-compliant RUM.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
