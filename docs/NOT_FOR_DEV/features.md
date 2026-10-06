# {PRODUCT_NAME} (Metria | Assessia, final name TBD) — FEATURE SKETCH

Purpose: TA/teacher-facing evaluation, marks and coursework platform for university students. Revenue: ads (+ direct sponsors), shared with TAs.
Legend: [P1] launch  [P2] soon after  [P3] delayed  [OPT] optional/decide later
This is a feature sketch only. Architecture, schema and stack are decided in separate docs.

---
## 0. GLOBAL CONSTRAINTS (apply to every feature)
- G1. Two layers: PUBLIC (indexable, for search traffic) and PRIVATE (login-required, noindex). Ads are allowed on BOTH layers (see 10); ad rules are config-driven, not hard-coded.
- G2. SEO guidance (soft, not blocking): keep public pages reachable without login where practical; login only when an action needs it. Login/auth callback pages are noindex.
- G3. Server-rendered public pages, sitemap, robots, OpenGraph/link previews, reasonable page speed. Ad scripts load async/deferred so they don't block the page.
- G4. Multi-tenant from day 1: every record belongs to a university (university_id). Launch with FAST-NUCES Lahore only; other universities enabled later (P3) without schema change.
- G5. Authorization enforced at the database/server level (e.g. row-level security), never only in the UI. A student can never read another student's data.
- G6. Mobile-first responsive UI; installable PWA.
- G7. Everything user-generated (reviews, chat, objections) has report/block/moderation tools.
- G8. Privacy by default: minimal personal data, delete-my-data on request, marks/transcripts treated as sensitive.
- G9. New business-owned accounts for all services (own Google account, GitHub Organization, Supabase, Search Console, ad accounts). Custom domain.

## 1. AUTH & ROLES [P1]
- 1.1 Google sign-in, restricted per university by an allowed-email-domain list (FAST: @lhr.nu.edu.pk). Non-allowed accounts see an access-denied page.
- 1.2 Roles: Student, TA, Teacher (instructor), Platform Admin (us). Remove any hard-coded admin; roles are data, assigned by invite/approval.
- 1.3 A TA can own multiple courses and sections; students enroll in sections.
- 1.4 Profile page: name, roll no, sections, optional public links (LinkedIn, GitHub) shown only if the user opts in.

## 2. CORE: COURSES, SECTIONS, ASSESSMENTS, MARKS [P1] (carry over from current product)
- 2.1 TA CRUD: students, courses, sections, assessments (quiz/assignment/exam, weight, total).
- 2.2 Marks entry: manual and CSV bulk upload (student_email, score). Importer shows a preview with counts: ready / not found / duplicates / invalid, and writes nothing until the TA confirms.
- 2.3 Student marksheet: own marks per assessment, weighted total, class stats (min/max/avg), anonymized leaderboard/rank.
- 2.4 Announcements per course/section.
- 2.5 TA analytics: distribution charts, per-section stats.
- 2.6 Student dashboard (home): upcoming evaluations, bookings, latest marks, announcements.

## 3. EVALUATION SLOT BOOKING [P1 base, P2 social features]
- 3.1 [P1, carry over] TA creates evaluation periods and slots with capacity; student books one slot per period; capacity and one-booking-per-period enforced by the database; student sees own bookings; TA sees all bookings.
- 3.2 [P1] Cancel/reschedule within rules set by TA (cutoff time).
- 3.3 [P2] Public view of schedule and open-slot counts (no personal data).
- 3.4 [P2] Students booked in the same period can see each other (name only), chat, and propose slot swaps. A swap needs mutual consent from both students; TA can disable per period.
- 3.5 [P2] Reminders (email/push) before the slot; add-to-calendar (.ics / Google Calendar link).
- 3.6 [P2] Waitlist for full slots.

## 4. MARKS OBJECTIONS [P1/P2]
- 4.1 Student raises an objection on a specific mark (replaces email): reason text, optional attachment link.
- 4.2 TA sees an inbox, replies in a thread, and sets status (open / under review / resolved / rejected). Mark changes made from an objection are logged (audit trail: who, when, old→new).
- 4.3 Notifications on status change.

## 5. MESSAGING [P2]
- 5.1 Student ↔ TA direct chat and section-wide group chat (TA-controlled: announce-only or open).
- 5.2 Rules: report/block, TA can mute students, message retention policy, no file storage (links only).
- 5.3 Ad placement on chat pages is controlled by the ad config (see 10); default = no pop-style formats inside the chat view.

## 6. COURSEWORK (Google Classroom replacement) [P2]
- 6.1 Announcements (rich text, pinned, optional notify).
- 6.2 Assignments: description, deadline, rubric, GUIDE section (how to approach it). Guides can be marked public (feeds SEO pages, G1).
- 6.3 Submissions as a gateway: students submit links (Drive/GitHub/etc.), no file storage on our side. Deadline, late flag, TA review status.
- 6.4 Course info page (outline, grading policy, resources, TA contact).

## 7. TIMETABLE & CALENDAR [P2]
- 7.1 Personal timetable (classes, evaluations, deadlines) in one view; ICS export + subscribe link.
- 7.2 [P3] Mutual free-slot finder (student↔TA, student↔student) from timetables.

## 8. TA-SPECIFIC FEATURES [P2/P3]
- 8.1 [P2] TA reviews by students: anonymous, moderated, shown only in aggregate after a minimum number of reviews.
- 8.2 [P2] TA public profile (opt-in): courses, schedule, LinkedIn/GitHub links, aggregate rating. Indexable.
- 8.3 [P3] TAship eligibility chart: user uploads timetable + transcript; processed in the browser/ephemerally (not stored); shows which TAships they could apply to.
- 8.4 [P3] TAship application mails: generate a draft email and a send link. No Gmail-send permission at launch.
- 8.5 [P3] Networking: see a TA's LinkedIn/GitHub (opt-in only).
- 8.6 [P2] TA invite link so a TA can onboard their own sections.

## 9. TEACHER REVIEWS [P3, high risk, launch last]
- 9.1 Students review a teacher after the semester; TAs review a teacher before the semester.
- 9.2 Anonymous, moderated, aggregate-only with a minimum-review threshold; reporting and takedown flow; legal/university-risk disclaimer.

## 10. MONETIZATION [P1]
- 10.1 Ads run on public AND private pages, including marks, dashboard, schedule, announcements, bookings. Admin can toggle per page type: banner, native, social bar, in-page push, pop-under, smartlink. Default: all page types enabled EXCEPT login/auth pages (login page ads look like phishing next to Google sign-in).
- 10.2 One ad-config layer (per page type: network, format, on/off, frequency cap) so networks can be switched or stacked without code changes. Planned networks: Adsterra first, then Monetag or similar. AdSense is out of scope for now (its rules would conflict with these formats).
- 10.3 Safety defaults: block adult/gambling/dating/VPN categories in each network's settings; frequency cap on pop-style formats (default 1 per user per 24h, max one pop-style format active at a time); one-click global kill switch per network if bad ads appear.
- 10.4 Ad slots not placed directly on top of action buttons (Book, Submit, Raise objection). Never ask or incentivize users to click ads.
- 10.5 Direct-sponsor slots: admin-managed banners (image, link, dates, "Sponsored" label).
- 10.6 Consent/cookie notice; each network listed in the Privacy Policy.
- 10.7 [P2] Visit counting (own first-party, bot-filtered, unique visits per page/TA/course/month).
- 10.8 [P2] TA revenue share: configurable model (percentage of actual earnings attributable to a TA's pages, or rate per 1,000 visits; default = percentage). Admin enters actual monthly earnings per network; TA dashboard shows visits, platform vs TA share, and payout history (transparent).
- 10.9 [P2] Payout tracking (manual payouts via bank/Easypaisa/JazzCash, minimum payout, status).

## 11. PUBLIC / SEO / TRAFFIC [P1/P2]
- 11.1 [P1] Home, About, Contact, Terms of Service, Privacy Policy, Cookie notice, "not affiliated with any university" disclaimer.
- 11.2 [P1] Public content: course pages, public TA pages, assignment guides, blog/guides section.
- 11.3 [P1] Calculators: CGPA/GPA, FAST-style grading/relative-grading, "marks needed in finals for target grade", attendance.
- 11.4 [P2] General TA tools for any TA worldwide (rubric builder, CSV→gradesheet, etc.) in English.
- 11.5 [P1] SEO basics: sitemap, structured data, unique titles/descriptions, OG images, internal links, Search Console + analytics.
- 11.6 [P2] WhatsApp/one-tap share buttons with link previews (schedule, announcements, calculators).

## 12. CHATBOT [P2]
- 12.1 Starts as FAQ/search over public help content + the user's own schedule (rule-based).
- 12.2 [P3] AI answers with rate limits and per-user quotas. Must never access other users' data.

## 13. NOTIFICATIONS & MOBILE [P2]
- 13.1 PWA (installable) first: web push (Android; iOS only for installed PWAs), email notifications, in-app inbox, user-controlled preferences.
- 13.2 If an ad network's push format is enabled, avoid showing it together with our own notification permission prompt (one prompt at a time, ours takes priority).
- 13.3 Native Android/iOS apps are LONG TERM (not in this scope).

## 14. ADMIN (PLATFORM) [P1/P2]
- 14.1 University management: allowed domains, enable/disable a university.
- 14.2 User/role management, content moderation queue, reports, bans.
- 14.3 Ad config and sponsor management (see 10), including per-network kill switch.
- 14.4 Audit log of sensitive actions (mark edits, role changes).

## 15. MIGRATION / CLEANUP [P1]
- 15.1 One-time import of existing NUSkor data (1 TA, 2 assignment evaluations across 3–4 sections) into the new schema; keep old site live until cutover, then 301-redirect to the new domain.
- 15.2 Fix current inconsistencies (login problems etc.); a single reliable login flow.

## OUT OF SCOPE (long term)
- ML/AI features (semester progress, final grade prediction), native mobile apps.
