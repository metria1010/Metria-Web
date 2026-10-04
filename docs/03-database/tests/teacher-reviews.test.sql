> Purpose: pgTAP RLS and schema smoke tests
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(5);
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.teacher_reviews'::regclass),'teacher_reviews has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.teacher_review_authors'::regclass),'teacher_review_authors has RLS');
SELECT ok(to_regprocedure('private.current_university_ids()') IS NOT NULL,'tenant helper installed');
SELECT ok(NOT has_table_privilege('anon','public.profiles','SELECT'),'anonymous cannot select profiles');
SELECT ok(NOT has_table_privilege('anon','public.marks','SELECT'),'anonymous cannot select marks');
SELECT * FROM finish();
ROLLBACK;

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
