# METRIA — PLANNING BRIEF
### Source-of-truth input for the Dev-Plan Generator Agent
Version 1.0 · Companion files: `features.md` (feature sketch, authoritative for feature IDs), `GENERATOR_PROMPT.md` (the instruction prompt)

---

## 0. HOW TO USE THIS DOCUMENT

**Audience:** an AI agent that will produce the complete, rigid development documentation for Metria (many large files). That documentation will then be executed by **two human co-founders, each working with AI coding agents ("vibe coding")**.

**Authority order (highest wins on conflict):**
1. Section 3 (Engineering Principles) and Section 7 (Mandatory Mitigations) of this brief
2. Section 2 (Locked Decisions) and Section 13 (Decision Defaults) of this brief
3. `features.md` (feature IDs, phases, behavior)
4. The rest of this brief
5. Your own judgment (only where all of the above are silent, and you must record it as an ADR)

**Rules of engagement:**
- Never silently drop, merge, or weaken a feature from `features.md`. Every feature ID must appear in the traceability matrix with phase, owner lane, tables, routes, and task cards.
- Never leave a placeholder (`TBD`, `...`, "similar to above", "etc."). Every file you produce must be complete and directly executable by a coding agent.
- If something is ambiguous, apply the default from Section 13 and log it in `DECISIONS.md`. Do not stall and do not ask questions.
- Point 15 (Migration/Cleanup) of `features.md` is **out of scope**: this is a from-scratch build. No NUSkor import, no 301 redirects. Keep only 15.2's spirit: one single, reliable login flow.
- Product name is not final (Metria | Assessia). Treat it as a config value (`NEXT_PUBLIC_PRODUCT_NAME`, DB `platform_settings`), never hard-code it in code, schema, or copy.

---

## 1. PRODUCT & BUSINESS CONTEXT

- **What:** TA/teacher-facing evaluation, marks, and coursework platform for university students (Google-Classroom-replacement features plus slot booking, marks objections, reviews, calculators, timetables).
- **Launch tenant:** FAST-NUCES Lahore only (email domain `lhr.nu.edu.pk`). Architecture must support unlimited universities without schema change.
- **Revenue:** advertising (Adsterra first, then Monetag or similar; direct sponsors), with a transparent revenue share to TAs. **Traffic is the business.** Every design decision must be evaluated for: (a) organic search traffic, (b) pages-per-session / return visits, (c) ad viewability without breaking UX or trust.
- **Team:** 2 co-founders, each paired with AI coding agents. Plans must be executable with minimal cross-talk and minimal merge conflicts.
- **Not affiliated with any university.** Disclaimer is mandatory in the footer and legal pages.
- **Primary market constraints:** Pakistan (PKR, Asia/Karachi timezone, JazzCash/Easypaisa/bank payouts, mobile-first, often low-bandwidth Android devices, WhatsApp as main share channel).

---

## 2. LOCKED DECISIONS (do not re-open; deviations require a justified ADR)

| # | Decision |
|---|---|
| L1 | **Backend platform:** Supabase (Postgres, Auth, Storage only if unavoidable, Realtime, Edge Functions, `pg_cron`, `pgmq` or equivalent queue). |
| L2 | **Frontend:** Next.js (App Router) + TypeScript (strict) + Tailwind + shadcn/ui, server-rendered public pages (SSG/ISR/SSR per route), deployed on a free self-hostable platform (implementation-agnostic; chosen at deployment). |
| L3 | **No ORM.** `supabase-js` + generated TypeScript types from the DB schema; transactional business logic lives in Postgres functions (RPC) so future native apps reuse it. |
| L4 | **Migrations only** via Supabase CLI. No dashboard schema edits, ever. |
| L5 | **Modular monolith**, single repo, single Next.js app, feature-folder structure. No microservices. |
| L6 | **Auth:** Google sign-in only at launch, restricted by per-university allowed-domain list, enforced **server-side** (Supabase Auth hook / trigger), not just in UI. |
| L7 | **Authorization:** Row-Level Security on every table with a `university_id` (and on all other tables too). UI checks are cosmetic only. |
| L8 | **Money:** integer minor units + ISO currency code, never floats. |
| L9 | **Time:** stored in UTC (`timestamptz`), displayed in the university's timezone (`universities.timezone`, default `Asia/Karachi`). |
| L10 | **Business-owned accounts** for every service (G9). The plan must include a "Day 0 accounts & secrets" checklist. |
| L11 | **Testing stack:** Vitest (unit), Playwright (e2e), pgTAP (database + RLS tests), plus CI on every PR. |
| L12 | **Language:** English UI at launch, i18n-ready (`next-intl` scaffold; no hard-coded strings in components). |

---

## 3. ENGINEERING PRINCIPLES (non-negotiable; every file you generate must obey them)

**Schema rigidity and extensibility**
- P1. **Multi-tenancy:** every tenant-owned row has `university_id NOT NULL`. Use **composite foreign keys** `(university_id, id)` for child tables so a row can never reference a parent in another university.
- P2. **Terms (semesters) are first-class.** Separate the **catalog** (`courses`: stable, public/SEO) from **offerings** (`course_offerings` = course + term) and **sections** (offering + section code). Marks, bookings, and coursework hang on offerings/sections, never directly on catalog courses.
- P3. **Roles are data**, scoped per university: `roles`, `role_assignments`, plus a `platform_admins` table for global admins. A user can hold different roles in different universities and different roles per offering (e.g., Student in one, TA in another). Include a `permissions` catalog and `role_permissions` so new roles (e.g., Department Admin) need data, not schema changes.
- P4. **Lookup tables or `text` + CHECK over Postgres ENUMs** for anything likely to grow (statuses, ad formats, page types, notification channels). Native ENUMs are allowed only for truly closed sets and must be justified.
- P5. Every table: `id uuid PK default gen_random_uuid()`, `created_at`, `updated_at` (trigger), plus `created_by` where relevant and `deleted_at` for soft-deletable entities. Hard deletes only via the documented purge jobs (G8).
- P6. **Append-only history** for sensitive values: `mark_history` (who, when, old→new, reason, source = manual/csv/objection), `audit_log` (immutable, no UPDATE/DELETE grants), `role_assignment_history`.
- P7. **Expand/contract migrations**: never rename or drop in one step; every migration has a rollback note; destructive changes need a two-release path.
- P8. `jsonb` columns only for explicitly listed extension points (e.g., `settings`, `metadata`) with a documented JSON schema; never for core relational data.
- P9. **Idempotency everywhere** async or user-retriable: CSV imports (import batch id + row hash), notifications (outbox + dedupe key), payouts, earnings entries, cron jobs.
- P10. **Feature flags** in DB (`feature_flags`, scoped global/university) for every P2/P3 feature, so unfinished modules can ship dark and be enabled per university.

**Security and privacy**
- P11. RLS **default-deny**. Each table's plan lists: policy per role/operation, plus at least one pgTAP test per policy (allowed case + denied case + cross-tenant case).
- P12. `SECURITY DEFINER` functions live in a non-exposed schema, set `search_path = ''`, validate `auth.uid()` internally, and are listed in a function registry with their intended caller roles.
- P13. **Public layer reads only through whitelisted views/functions** (`public_*`), never directly from private tables. Public data has an explicit publication state (`draft → pending_review → published → unpublished`), and a student's personal data can never appear in a public view.
- P14. **Aggregates are privacy-gated:** class stats, leaderboards, review aggregates, and booking counts are computed server-side with minimum-cohort thresholds (default k ≥ 5; reviews minimum configurable), and rank is shown without identities.
- P15. Rate limits on all write endpoints, auth-adjacent endpoints, chat, uploads-of-links, and (future) AI endpoints. Input validation with zod on every server boundary.
- P16. Secrets only in env/Supabase vault; a documented `.env.example`; service-role key never reaches the browser.

**Reliability / fault tolerance**
- P17. **Outbox pattern** for emails, push, and any external call; retries with exponential backoff; dead-letter table; admin visibility.
- P18. **Ads can never break the product:** ad scripts load async/deferred after consent, in isolated slot components with reserved height (CLS budget), wrapped in error boundaries; a failing or blocked ad network results in an empty slot, never a broken page.
- P19. Booking correctness (capacity and one-booking-per-period) must hold under concurrent requests: enforced by DB constraints + a transactional RPC with row locking. A concurrency test is mandatory.
- P20. Observability: structured logs, Sentry (frontend + edge functions), uptime check, DB slow-query review, a runbook per critical failure (login down, bad ad, DB full, email provider down).
- P21. Backups: daily backups enabled where the plan allows; restore drill documented. Know the limits of free tiers (see R9).

**Developer experience for AI coding agents**
- P22. Plans must be **agent-executable**: small, self-contained, ordered task cards with exact file paths, exact acceptance criteria, and tests. An agent must be able to complete a card reading only that card plus the files it links.
- P23. A single **Symbol Registry** (tables, columns, functions, enums, routes, env vars, feature flags, permissions, event names) is the naming source of truth; every other file must use exactly those names.
- P24. No file exceeds ~700 lines; split by module. Prefer more small files with an index over monoliths.

---

## 4. FEATURE REQUIREMENTS (what the generator must specify per module)

For every module below, produce: user stories (Given/When/Then), screens/routes, data model (full DDL), RLS policies + tests, RPC/Edge functions, UI components, SEO spec (if public), ad slots (if any), notifications emitted, audit events, analytics events, feature flag, phase, owner lane, and task cards. Feature IDs refer to `features.md`.

### 4.1 Foundation & Auth (G1–G9, §1) · P1
- Tenancy (`universities`, domains, settings), auth hook enforcing allowed domains, access-denied page, `profiles`, `university_memberships`, role assignment by invite/approval (invite tokens, expiry, single-use), TA/Teacher onboarding approval queue. No hard-coded admin: first Platform Admin is bootstrapped via a one-time documented SQL seed using env-provided email.
- Profile: name, roll no (unique per university), optional public links with explicit opt-in flags (1.4).
- Specify the PWA shell, layout system, design tokens, mobile-first navigation, offline fallback page, and global error/empty/loading states.

### 4.2 Core academics (§2) · P1
- Entities: terms, departments, courses, course_offerings, sections, enrollments, assessments (type, weight, total, visibility), marks, mark_history, import_batches + import_rows.
- **CSV importer (2.2):** two-phase (parse → preview with counts: ready / not found / duplicates / invalid → confirm). Nothing written to `marks` before confirm; preview is stored server-side with expiry; confirm is idempotent. Specify file-size/row limits and error CSV download.
- Marksheet (2.3): weighted total, handling of missing/pending marks, class stats and anonymized rank via privacy-gated RPC.
- Announcements (2.4), TA analytics (2.5, charts: distribution, per-section stats), Student dashboard (2.6; aggregates upcoming evaluations, bookings, latest marks, announcements in a single RPC to keep it fast).

### 4.3 Evaluation slot booking (§3) · P1 base, P2 social
- `evaluation_periods`, `slots` (capacity, start/end, location/link), `bookings`. Unique `(period_id, student_id)` active booking; capacity enforced by RPC with locking plus a safety trigger. Cancel/reschedule cutoff per period (3.2).
- P2: public schedule with open-slot counts only (3.3); same-period peer visibility (name only), chat, mutual-consent swap requests with TA per-period disable (3.4; swap = atomic two-party RPC); reminders (3.5) and ICS/Google Calendar link; waitlist with auto-promotion on cancellation (3.6).

### 4.4 Marks objections (§4) · P1/P2
- `objections`, `objection_messages`, status machine (open → under_review → resolved | rejected), attachment is a URL only. Mark change from an objection must go through one RPC that writes `mark_history` + `audit_log` atomically. Inbox for TA, notifications on status change. Rate-limit objections per student per assessment.

### 4.5 Messaging (§5) · P2
- `conversations` (direct | section_group), participants, messages, `message_reports`, `blocks`, `mutes`. TA-controlled announce-only vs open mode. Supabase Realtime with RLS-correct channels. Retention policy job. **Link-only, no file storage.** Moderation hooks (G7). Ad placement default: no pop-style formats inside the chat view (5.3).

### 4.6 Coursework (§6) · P2
- Announcements (rich text, sanitized; pinned; optional notify), assignments (description, deadline, rubric, guide), guide visibility (public flag feeds SEO), link submissions (late flag, review status, TA feedback), course info page.
- Rich-text storage format must be specified (recommend sanitized HTML or ProseMirror JSON with server-side sanitization) and XSS tests included.

### 4.7 Timetable & calendar (§7) · P2/P3
- Personal timetable aggregates class meetings, evaluations, deadlines; ICS export and **tokenized subscribe URL** (revocable token, no auth cookie). P3: mutual free-slot finder operating on timetable data without exposing details (only free/busy).

### 4.8 TA features (§8) · P2/P3
- TA reviews (anonymous, moderated, aggregate-only after min count; store reviewer identity separately from review content to guarantee anonymity while preventing duplicate reviews), public TA profile (opt-in, indexable), TA invite link, P3 eligibility chart (client-side/ephemeral processing; **nothing stored server-side**; specify the parsing approach, supported formats, and a privacy proof in docs), P3 application mail draft + `mailto:`/Gmail compose link only (no Gmail send scope), opt-in networking links.

### 4.9 Teacher reviews (§9) · P3, launch last
- Same anonymity mechanics as TA reviews; takedown flow, legal disclaimer, kill switch via feature flag, moderation queue with SLA. Mark as highest legal risk (see R4).

### 4.10 Monetization system (§10) · P1 (+P2 for 10.7–10.9)
Specified in detail in Section 6.6 and 6.7.

### 4.11 Public / SEO / Traffic (§11) · P1/P2
Specified in detail in Section 6.8. Includes legal pages, public content, calculators, TA tools, share buttons.

### 4.12 Chatbot (§12) · P2/P3
- P2: rule-based intent matcher over `help_articles` + the user's own schedule (via the same RLS-protected RPCs; it gets no extra privileges). P3: AI gateway with per-user quotas and a strict tool boundary (the model never receives data from a different user; context assembled server-side under the caller's identity). Include prompt-injection mitigations and cost caps.

### 4.13 Notifications & mobile (§13) · P2 (in-app inbox earlier if cheap)
- Central notification service: `notification_events` → `notification_deliveries` per channel (in_app, email, web_push), per-user preferences, quiet hours, digest option. Web push via VAPID; iOS only for installed PWAs. One-prompt-at-a-time rule between our permission prompt and any ad-network push format (13.2), implemented in one shared "permission prompt coordinator".
- Native apps: out of scope, but the API surface (RPC + typed contracts) must not preclude them.

### 4.14 Admin (§14) · P1/P2
- Universities & domains, users/roles, moderation queue (generic over content types), reports, bans, ad config + sponsors + kill switch, audit viewer, feature flags UI, import/earnings entry screens, system health page.

---

## 5. DOMAIN ENTITY CATALOG (starting point; generator finalizes with full DDL)

Group → candidate tables (names are suggestions; the final names live in the Symbol Registry).

- **Tenancy/Identity:** `universities`, `university_domains`, `profiles`, `university_memberships`, `roles`, `permissions`, `role_permissions`, `role_assignments`, `platform_admins`, `invites`, `platform_settings`, `feature_flags`
- **Academic structure:** `departments`, `terms`, `courses`, `course_offerings`, `sections`, `enrollments`, `offering_staff` (TA/teacher ↔ offering/section), `grading_scales` (per university; supports FAST-style relative grading + calculators)
- **Assessment/marks:** `assessments`, `marks`, `mark_history`, `import_batches`, `import_rows`, `announcements`
- **Booking:** `evaluation_periods`, `slots`, `bookings`, `waitlist_entries`, `swap_requests`
- **Objections:** `objections`, `objection_messages`
- **Messaging/moderation:** `conversations`, `conversation_participants`, `messages`, `reports`, `blocks`, `mutes`, `moderation_actions`, `bans`
- **Coursework:** `assignments`, `assignment_guides`, `submissions`, `course_info_pages`
- **Calendar:** `timetable_entries`, `calendar_tokens`
- **Reviews:** `ta_reviews`, `ta_review_authors` (separate, restricted), `teacher_reviews`, `teacher_review_authors`, `review_aggregates` (materialized/cached, threshold-gated)
- **Public/SEO:** `public_profiles`, `content_pages` (blog/guides), `help_articles`, `redirects`, `seo_overrides`, `calculators` registry
- **Notifications:** `notification_events`, `notification_deliveries`, `notification_preferences`, `push_subscriptions`, `email_log`
- **Ads/Monetization:** `ad_networks`, `ad_formats`, `page_types`, `ad_placements`, `ad_config_versions`, `ad_kill_switches`, `sponsors`, `sponsor_creatives`, `sponsor_slots`
- **Analytics/Revenue:** `page_visits_raw` (partitioned by month), `page_visits_daily` (aggregates), `earnings_entries`, `revenue_share_models`, `revenue_allocations`, `payout_accounts`, `payouts`, `payout_events`
- **Platform:** `audit_log`, `outbox_jobs`, `dead_letters`, `rate_limit_counters`, `ai_usage` (P3), `data_deletion_requests`
- **Reserved extension points (design for, don't build):** `entitlements` (future premium/ad-free), `organizations/departments admins`, per-university custom grading schemes, multiple currencies/FX, `pgvector` embeddings for semantic search/AI, ML feature tables fed from event data.

---

## 6. CROSS-CUTTING SPECIFICATIONS (generator must expand each into its own file set)

### 6.1 Tenancy & RLS framework
- Define helper functions (in a private schema): `current_university_ids()`, `has_role(university_id, role)`, `is_offering_staff(offering_id)`, `is_enrolled(section_id)`, `is_platform_admin()`. Use the `(select auth.uid())` initPlan pattern for performance.
- Provide a **policy matrix** (table × role × operation) for every table, SQL for every policy, and a pgTAP test file per module. Include a **cross-tenant attack test suite** (user from University B must see/modify nothing from A).
- Specify service-role usage rules (only Edge Functions/cron, never client).

### 6.2 Visibility / publication model
- Layers: PRIVATE (login, `noindex`), PUBLIC (indexable). Define a `visibility` state model per content type (course, TA profile, guide, schedule view) and the exact public views, columns exposed, caching and revalidation triggers (on-demand ISR when published/unpublished).
- Define what is public by default vs. opt-in. TA profile and student data are **opt-in only**.

### 6.3 Audit & history
- Audit event catalog (mark edits, role changes, ad config changes, payout changes, bans, moderation decisions, data deletions) with fixed payload schema, written by triggers/RPCs, immutable.

### 6.4 Notifications engine
- Event catalog, templates (email + push + in-app), preferences resolution, dedupe keys, retry/backoff, DLQ, admin replay tool, unsubscribe link compliance.

### 6.5 Search, config, flags
- Postgres full-text search + `pg_trgm` for public search (courses, TAs, guides). Feature flags and `platform_settings` cache strategy (edge-cached, invalidated on change).

### 6.6 **Ad system (core business; highest-detail spec required)**
Requirements from `features.md` §10, expanded:
1. **Config-driven resolution:** for a request `(university, page_type, slot, user context, consent)` the system returns the list of ad units to render. Config is versioned (`ad_config_versions`) with instant rollback. Cache at the edge; admin changes propagate within a defined TTL.
2. **Page type registry** (data, not code): `home`, `about`, `public_course`, `public_ta`, `guide`, `blog`, `calculator`, `ta_tool`, `dashboard`, `marksheet`, `schedule`, `announcements`, `bookings`, `objections`, `chat`, `coursework`, `profile`, `admin`, `login/auth` (always off, enforced in code **and** DB constraint), plus any future types added by data.
3. **Formats registry:** banner, native, social bar, in-page push, pop-under, smartlink, direct sponsor. Each format declares `is_pop_style`, `needs_consent`, `injection_mode` (inline component, global script, link rewrite), and allowed page types.
4. **Per page-type × network × format** settings: on/off, frequency cap, priority/stack order, slot IDs, device targeting.
5. **Frequency caps for pop-style formats:** default 1 per user per 24h and at most one pop-style format active per page; enforced client-side (storage) with a server-config source of truth. Specify exactly how "user" is identified for anonymous visitors (first-party storage, no fingerprinting).
6. **Kill switch:** one-click per network, takes effect on next page load at most TTL seconds later, plus a global kill. Must work even if the admin app is slow (documented direct-SQL emergency procedure in the runbook).
7. **Safety defaults:** category blocks (adult/gambling/dating/VPN) are configured in each network's dashboard; the plan must include a **per-network setup checklist** and a periodic "ad QA" routine (manual spot-check scripts, screenshots, reporting bad creatives to networks).
8. **Layout rules:** reserved slot dimensions (CLS ≤ 0.1 including ads), lazy loading below the fold, no ad directly over or adjacent (min spacing token) to action buttons (Book, Submit, Raise objection), "Sponsored" labels on direct sponsors, never request or incentivize clicks. Provide a lint/test (Playwright) that asserts spacing and no-ads-on-auth-pages.
9. **Direct sponsors:** admin-managed creatives (image URL, link, dates, label, targeting by page type/university), impression/click counting (first-party, bot-filtered), expiry automation.
10. **Consent:** cookie/consent banner gating ad scripts (consent categories stored; region-aware defaults specified), each network listed in the privacy policy (generated from `ad_networks` data so it never drifts).
11. **Ad script isolation & CSP:** see R1; specify a CSP strategy (report-only first, then enforce), `Permissions-Policy`, and iframe sandboxing where the format allows.
12. **Extensibility:** adding a new network = inserting data + a small adapter file (documented adapter interface), no changes to pages.

### 6.7 Analytics, visit counting & revenue share (P2, but schema must be ready at P1)
- **First-party, privacy-preserving visit counting:** event ingestion endpoint (edge), bot filtering (UA lists, headless heuristics, rate limits, no-JS ignore), uniqueness via daily-rotating salted hash (no persistent identifiers, no raw IP storage), attribution to `(page_type, entity_type, entity_id, ta_id, course_id, offering_id, month)`.
- Storage: `page_visits_raw` partitioned monthly with retention (e.g., 90 days) → `page_visits_daily` aggregates by cron; rollups by month for payouts. Specify partition management automation.
- **Attribution rules** (must be written precisely): which page types credit which TA (own public profile, guides authored, section pages, private pages of sections they run, calculators = platform-owned, etc.). Shared pages credit the platform. Rules are data (`attribution_rules`), versioned.
- **Revenue share:** `revenue_share_models` (percentage [default] or rate per 1,000 visits), versioned with effective dates; admin enters `earnings_entries` per network per month (amount, currency, FX rate to PKR if needed, source statement reference); a **monthly closing job** produces immutable `revenue_allocations` (platform share vs TA share, model version, inputs snapshot). TA dashboard shows visits, shares, history. Corrections are new adjusting entries, never edits.
- **Payouts (10.9):** `payout_accounts` (method: bank/Easypaisa/JazzCash; store minimum identifying data; treat as sensitive, encrypt at rest or restrict via RLS + column privileges), minimum payout threshold, status machine (pending → approved → paid | failed | cancelled), manual proof reference, audit trail.
- Provide the full worked example (numbers) in docs and a SQL test reproducing it.

### 6.8 SEO & traffic engine (maximum-traffic mandate)
Produce an **SEO master spec** and a **programmatic content plan**:
- **Route map** with: URL pattern, rendering strategy (SSG/ISR/SSR), revalidation, indexability, canonical, title/description templates, H1 rules, structured data type (Course, Person, FAQPage, HowTo, BreadcrumbList, Article, SoftwareApplication for calculators, WebSite+SearchAction), OG image template (dynamic via a self-hosted renderer, e.g. Satori + resvg), internal-link rules, and ad slots.
- **Public page inventory:** home, about, contact, legal pages; university hub pages; department → course catalog → course detail pages (programmatic, from catalog data); public TA pages (opt-in); assignment guides (public flag); blog/guides section with a content calendar and editorial workflow (admin editor, draft/publish, scheduled publish); help center; calculators.
- **Calculators (P1, highest organic potential):** CGPA/GPA, FAST-style absolute and relative grading, "marks needed in finals for target grade", attendance (percentage and "classes I can still miss"). Specify formulas rigorously, grading scale data model (`grading_scales`, editable per university), edge cases, unit tests, shareable result URLs (query-param state, `noindex` for parameterized variants, canonical to base), print/share/WhatsApp buttons (11.6), and long-tail landing variants (e.g., per grading policy).
- **TA tools (P2, English, any TA worldwide):** rubric builder, CSV→gradesheet, others; client-side processing where possible, no login, strong SEO landing pages, upsell to the platform.
- **Technical SEO:** sitemap index split by content type with `lastmod`, robots rules (private/auth paths disallowed + `noindex`), 404/410 handling, redirects table, hreflang-ready, canonical rules, pagination rules, image optimization, font strategy, JS budget, Core Web Vitals targets (LCP < 2.5s on mid-range Android over 4G, INP < 200ms, CLS < 0.1 **with ads**), RUM collection of CWV.
- **Growth loops:** WhatsApp/one-tap sharing of schedules/announcements/calculators with rich link previews; public schedule links; "add to calendar"; TA invite links; return-visit drivers (reminders, announcements, marks-posted notifications) — specify each as a feature-flagged loop with metrics.
- **Measurement:** Search Console + GA4 (or privacy-friendly equivalent) setup checklist, event taxonomy, dashboards (organic sessions, pages/session, ad RPM per page type, conversion to signup).
- **Content safety for SEO:** thin/duplicate content rules, no student data ever in public pages, spam/UGC `rel="ugc nofollow"`, avoid indexing of faceted/param URLs.

### 6.9 Privacy & compliance
- Delete-my-data flow (`data_deletion_requests`): scope per table (delete vs anonymize vs retain-for-audit), SLA, admin tooling, verification of completion. Marks/transcripts classified as sensitive; transcript parsing never stored (8.3).
- Terms, Privacy Policy (auto-listing ad networks and cookies), Cookie notice, university-non-affiliation disclaimer, takedown/contact process, minimum-age statement, data retention table.

### 6.10 Moderation (G7)
- Generic `reports` + moderation queue over any content type (message, review, objection text, guide, profile link), actions (hide, warn, mute, ban), appeal note, audit entries, rate limits on reporting.

---

## 7. MANDATORY MITIGATIONS (risks the plan must address explicitly)

The founders have decided on aggressive monetization. **Implement it as specified**, but the plan must surface these risks in a "Founder Risk Register" file and implement the mitigations below.

- **R1. Ads on pages that show private marks.** Third-party ad scripts (especially top-level formats like social bar, in-page push, pop-under, smartlink) can read the page DOM and could capture marks or personal data. Mitigations: strict CSP + report-only monitoring; render only what the page needs; show sensitive values behind a lightweight "tap to reveal" on high-sensitivity pages (config-driven); allow per-page-type `isolation_mode` (`iframe_only`/`no_script_ads`) in config and ship defaults that follow the founders' choice (ads enabled) while making flipping to a safer mode a one-click admin action; incident runbook for "ad network misbehaving".
- **R2. SEO penalties from aggressive ad formats.** Pop-unders/smartlinks and malvertising can trigger browser Safe Browsing warnings and hurt rankings and trust. Mitigations: per-layer toggles (public vs private) so aggressive formats can be turned off on indexable pages instantly; monitoring checklist (Search Console Security Issues, Safe Browsing status check); frequency caps; kill switch.
- **R3. Auth-page trust.** No ads on login/auth (enforced by code and DB constraint), and no ad scripts loaded on those routes at all.
- **R4. Reviews legal exposure (TA/teacher reviews).** Anonymity must be technically real; takedown process; disclaimers; feature-flag kill switch; teacher reviews launch last.
- **R5. Anonymity leaks via small cohorts.** Minimum-count thresholds for every aggregate; no per-student breakdowns visible to peers.
- **R6. University/policy risk and name.** "Not affiliated" disclaimer; no use of university logos; product name configurable.
- **R7. Bot traffic and ad fraud.** Bot filtering in analytics; never encourage clicks; follow network ToS; rate-limit; document how self-clicking is prevented for the team (policy + QA tooling that does not trigger ad clicks).
- **R8. Consent/legal for cookies and analytics.** Consent gate for ad scripts; document the legal basis and keep the policy generated from data.
- **R9. Platform limits and terms.** The plan must include a **capacity & cost model** and a **service tier table**: the project is investment-free and must run entirely within free-tier limits (Vercel replaced by a free self-hostable deployment target; Supabase free-tier limits: DB size, egress, connections, pausing of inactive projects, no PITR). State monitoring thresholds and optimization triggers (archive/purge/index before any capacity change); no paid upgrade is planned. (Instruct: verify current free-tier terms at planning time.)
- **R10. Marks integrity.** Every mark mutation is logged; CSV import cannot silently overwrite (conflict mode: skip / overwrite-with-confirmation, defaulting to preview-and-confirm); TA cannot edit marks of offerings they don't staff (RLS-tested).
- **R11. Single points of failure for two founders.** Bus-factor docs: runbooks, account ownership checklist, secrets inventory, recovery steps.
- **R12. Payout disputes.** Immutable allocations, transparent TA dashboard, clear terms for revenue share, adjustments only via new entries.

---

## 8. TEAM SPLIT (two co-founders, each with AI coding agents)

Goal: **maximum parallelism, minimum merge conflicts, and a shared contract boundary.** The generator may refine, but must preserve these principles.

**Phase 0 — Joint Foundation (both, pair-style, sequential, ~first milestone):** repo, tooling, CI, env, design system skeleton, Supabase project setup, tenancy/auth/RLS framework, `AGENTS.md` rules, Symbol Registry v1, seed data, test harness. Nobody starts a lane until the **Foundation Gate** passes (checklist in the plan).

**Lane A — "Academic Core" (Founder A):** auth/roles UI, academics, marks + CSV importer, marksheet, announcements, booking (and P2 social/waitlist/reminders), objections, messaging, coursework, timetable, notifications engine, TA onboarding/invites.

**Lane B — "Growth & Money" (Founder B):** public layer & SEO engine, legal pages, content/blog system, calculators, TA tools, ad system (config, slots, consent, sponsors, kill switch), analytics/visit counting, revenue share + payouts, admin console (moderation, universities, flags, ad config), TA reviews/public TA profiles, chatbot, share loops.

> Lane A is feature-heavy and Lane B is system-heavy; the generator must **estimate effort per task card (S/M/L/XL with hour ranges) and rebalance** so each lane's totals are within ±15% per phase, moving modules (e.g., notifications UI, TA public profile, admin screens) as needed.

**Collision-avoidance rules to encode:**
- Directory ownership via `CODEOWNERS` (e.g., `/src/features/<module>` owned by one lane); shared packages (`/src/lib`, `/src/components/ui`, `/supabase/functions/_shared`) change only via small PRs reviewed by the other founder.
- **Migrations:** timestamped, but each file name prefixed with lane (`a_` / `b_`) and module; one migration per PR; schema ownership per module; a "schema change needs notice" protocol; rebase-before-merge rule; migration lint in CI.
- **Contract-first:** typed contracts (zod schemas + generated DB types + RPC signatures) are merged **before** consumers are built. Cross-lane dependencies are listed as explicit "interface tasks" with mock implementations so work never blocks.
- Cross-lane dependency map (e.g., Lane B's revenue attribution needs Lane A's `offering_staff`; Lane B's TA public page needs Lane A's courses) with the **earliest-needed contract** per dependency.
- Branching: trunk-based with short-lived feature branches, PR template, mandatory CI green, preview deployments, weekly integration checkpoints, phase gates requiring both lanes.
- Each lane's plan includes a **daily vibe-coding loop**: pick next card → open session with `AGENTS.md` + card → implement → run tests → update registry/docs → PR.

---

## 9. REQUIRED OUTPUT: DOCUMENTATION SET STRUCTURE

The generator must produce at minimum the following tree (it may add files, not remove). Each file must be complete.

```
docs/
  00-INDEX.md                      # reading order, how to use with AI agents, glossary
  DECISIONS.md                     # decision log + ADR index (every default applied from §13)
  SYMBOL_REGISTRY.md               # the naming source of truth (see P23)
  TRACEABILITY.md                  # feature ID -> phase -> lane -> tables -> routes -> task cards -> tests
  01-product/
    vision-personas-journeys.md
    modules/<one file per module in §4>.md   # user stories, rules, edge cases, acceptance criteria
  02-architecture/
    overview-and-diagrams.md       # mermaid: context, containers, data flow, auth flow, ad flow
    tech-stack-and-versions.md     # pinned versions, rationale, alternatives rejected
    repo-structure-and-conventions.md
    security-and-privacy.md
    capacity-cost-and-limits.md    # R9
    failure-modes-and-resilience.md# per-component failure, detection, fallback, recovery
  03-database/
    conventions.md
    schema/<module>.sql            # complete DDL: tables, constraints, indexes, triggers
    rls/<module>.sql               # all policies + helper functions
    functions/<module>.sql         # RPCs, security definer registry
    seed/                          # roles, permissions, page types, formats, grading scales, FAST university, dev fixtures
    tests/<module>.test.sql        # pgTAP incl. cross-tenant attacks and concurrency notes
    migration-plan.md              # ordered migration list per lane, naming, expand/contract rules
    data-lifecycle.md              # retention, partitions, deletion/anonymization matrix
  04-backend/
    api-contracts.md               # RPC + route handler + edge function signatures, zod schemas, error model
    edge-functions-and-jobs.md     # cron schedule, queues, idempotency, retries
    notifications-engine.md
    analytics-and-revenue-engine.md
  05-frontend/
    route-map.md                   # every route: access, rendering, SEO, ads, data deps, components
    design-system.md               # tokens, components, a11y, responsive rules, empty/error states
    pwa-and-push.md
    seo-master-spec.md
    page-specs/<route-group>.md    # wireframe-level descriptions + states + analytics events
  06-growth-and-ads/
    ad-system-spec.md
    ad-network-setup-checklists.md
    content-and-programmatic-seo-plan.md
    calculators-spec.md
    traffic-loops-and-metrics.md
  07-quality/
    test-strategy.md               # pyramid, tooling, coverage gates, test data
    ci-cd.md                       # pipelines, checks, preview envs, release process
    observability-and-runbooks.md
    security-checklist.md          # pre-launch audit
  08-delivery/
    lanes-and-ownership.md
    milestones-and-gates.md        # Phase 0..3 with Definition of Done per gate
    risk-register.md               # R1–R12 plus new ones
    lane-a/tasks/<NNN-slug>.md     # task cards (see §10)
    lane-b/tasks/<NNN-slug>.md
    shared/tasks/<NNN-slug>.md     # joint foundation cards
    dependency-graph.md            # card-level DAG + cross-lane interfaces
  09-ai-agent-setup/
    AGENTS.md                      # master rules for all coding agents (also CLAUDE.md, .cursorrules variants)
    prompt-library.md              # reusable session prompts: start card, review, debug, migration, RLS test, refactor
    context-packs.md               # per-module minimal file lists an agent should load
    definition-of-done.md
  10-ops/
    day0-accounts-and-secrets.md
    launch-checklist.md
    runbooks/*.md
    support-and-moderation-playbook.md
```

**Rendering rule:** every file starts with a header block: `Purpose · Audience · Prerequisites · Owner lane · Last verified against SYMBOL_REGISTRY version`.

---

## 10. TASK CARD STANDARD (mandatory format for every card)

```
# T-<LANE><NNN> <Title>
Phase: P0|P1|P2|P3        Lane: A|B|Shared        Size: S|M|L (hours range)
Depends on: T-...         Blocks: T-...           Feature IDs: e.g. 2.2, G5
## Goal (1–3 sentences)
## Context to load (exact file paths / doc sections only)
## Scope — files to create/modify (exact paths) and files NOT to touch
## Detailed steps (numbered, unambiguous)
## Data/contract changes (migration filename, tables, RPC signatures)
## Acceptance criteria (testable, Given/When/Then)
## Tests to write (unit/e2e/pgTAP, with names)
## Security & RLS checks
## SEO / Ads / Analytics hooks (if applicable)
## Definition of Done checklist
## Agent prompt (copy-paste block that starts a coding session for this card)
```
Cards must be sequenced so the app is **always deployable**. No card may exceed ~1 working day for an AI-assisted founder; split otherwise. Include "Stop and ask the human" triggers (e.g., needs a secret, needs a product decision).

---

## 11. GENERATION PROTOCOL (how the generator must work through the volume)

1. **Turn 0 — Plan only:** emit the full manifest (every file path with a one-line purpose, estimated size), the module list, the Symbol Registry v1 skeleton, the decision log (all defaults applied), the card numbering scheme, and the generation order. Wait for the human's "CONTINUE".
2. **Order:** DECISIONS → SYMBOL_REGISTRY → 03-database (schema → RLS → functions → tests, module by module) → 02-architecture → 04-backend → 05-frontend → 06-growth-and-ads → 07-quality → 08-delivery cards → 09-ai-agent-setup → 10-ops → TRACEABILITY (last, built from the cards).
3. **One file per response** (or a clearly numbered part of a big file). End each response with `NEXT: <path>` and the registry delta (new/changed symbols).
4. **Never abbreviate** ("etc.", "similar for other tables", "...", "omitted for brevity"). If a file would exceed limits, split it into numbered parts and continue.
5. **Consistency passes:** after schema files, run a self-audit (naming, FK integrity, RLS coverage per table, indexes for every FK and common filter). After task cards, run traceability audit: every feature ID covered by ≥1 card and ≥1 test; every table has RLS + tests; every route listed in the route map has a page-spec and an owner.
6. **Self-check block** at the end of every file: completeness checklist (✓/✗) against its header's promises.
7. If context is running out, emit a **Resume Pack** (manifest status, registry, last decisions) so a new session can continue seamlessly.

---

## 12. FINAL ACCEPTANCE CHECKLIST (the generated plan is rejected unless all pass)

- [ ] Every feature ID in `features.md` (except §15) is mapped in TRACEABILITY with phase, lane, tables, routes, cards, tests.
- [ ] Every table has: `university_id` (or documented exemption), RLS enabled, policies, indexes, pgTAP tests, audit/history where sensitive.
- [ ] Booking concurrency, CSV import idempotency, mark audit trail, objection → mark change atomicity, swap atomicity, waitlist promotion, payout immutability each have explicit tests.
- [ ] Public vs private layer separation is enforceable and tested (anonymous user cannot read any private table; public views expose whitelisted columns only).
- [ ] Ad system fully specified incl. kill switch, frequency caps, login-page exclusion constraint, CLS budget, consent gating, adapter interface.
- [ ] SEO master spec, route map with rendering strategies, structured data, programmatic content plan, and calculators spec with formulas and tests exist.
- [ ] Two-lane delivery plan balanced within ±15%, cross-lane interface tasks defined, `CODEOWNERS` and migration protocol specified.
- [ ] `AGENTS.md`, prompt library, and context packs exist and are consistent with the Symbol Registry.
- [ ] Risk register covers R1–R12 and capacity/cost model lists upgrade triggers.
- [ ] No placeholders, no contradictions between files, no invented requirements outside this brief (every addition logged as an ADR).

---

## 13. DECISION DEFAULTS (apply without asking; log in DECISIONS.md)

| ID | Question | Default |
|---|---|---|
| D1 | Package manager / runtime | pnpm, Node LTS, TypeScript strict, ESLint + Prettier, Husky/lint-staged |
| D2 | Data fetching | Server Components + server actions/route handlers for mutations; TanStack Query only for client-side realtime/interactive screens |
| D3 | Validation | zod shared between client, server, and contract docs |
| D4 | Email provider | Resend (abstracted behind an interface) with SPF/DKIM/DMARC checklist |
| D5 | Error tracking | Sentry; uptime via a free external monitor |
| D6 | Analytics | First-party visit counting (6.7) + GA4 and Search Console |
| D7 | Charts | Recharts (lazy-loaded, never on public critical path) |
| D8 | Rich text | Tiptap editor, stored as sanitized HTML plus JSON, sanitized on write and render |
| D9 | CSV | Papaparse client-side pre-parse for UX + authoritative server-side validation |
| D10 | Rank/stat threshold | k = 5 minimum cohort; review aggregate minimum = 5 (configurable) |
| D11 | Booking cutoff default | 6 hours before slot, TA-configurable per period |
| D12 | Message retention default | 180 days, configurable per university |
| D13 | Pop-style cap | 1 per user per 24h; max 1 pop-style format active per page |
| D14 | Visit-count raw retention | 90 days raw, aggregates kept indefinitely |
| D15 | Revenue share default | 50% of attributable earnings to the TA pool, configurable; confirm in Terms before launch |
| D16 | Payout minimum | PKR 2,000 (configurable) |
| D17 | Rate limiting | Postgres-backed counters for simple cases; Edge middleware limits for public endpoints |
| D18 | Environments | `local` (Supabase CLI), `staging` (separate Supabase project + preview deployment), `production`; seed scripts for each |
| D19 | Chat realtime | Supabase Realtime Postgres Changes/Broadcast with RLS; polling fallback |
| D20 | First admin bootstrap | SQL seed using `BOOTSTRAP_ADMIN_EMAIL`, executed once, audited |
| D21 | Accessibility | WCAG 2.1 AA target for core flows |
| D22 | Browser support | Last 2 versions of Chrome/Edge/Safari/Firefox, Android Chrome priority |

---

## 14. GLOSSARY

**TA** teaching assistant · **Offering** a course in a given term · **Section** a class group within an offering · **Evaluation period** a window in which students book viewing/viva slots · **Lane** one founder's ownership area · **Card** an atomic AI-executable task · **Gate** a phase checkpoint requiring both lanes · **Pop-style format** pop-under, in-page push, social bar, or smartlink type formats · **Kill switch** instant disable of a network or all ads · **Symbol Registry** the canonical list of names used across all docs and code.
