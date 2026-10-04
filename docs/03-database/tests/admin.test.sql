> Purpose: pgTAP RLS and schema smoke tests
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(7);
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.audit_log'::regclass),'audit_log has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.rate_limit_counters'::regclass),'rate_limit_counters has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.data_deletion_requests'::regclass),'data_deletion_requests has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.objection_rate_limits'::regclass),'objection_rate_limits has RLS');
SELECT ok(to_regprocedure('private.current_university_ids()') IS NOT NULL,'tenant helper installed');
SELECT ok(NOT has_table_privilege('anon','public.profiles','SELECT'),'anonymous cannot select profiles');
SELECT ok(NOT has_table_privilege('anon','public.marks','SELECT'),'anonymous cannot select marks');
SELECT * FROM finish();
ROLLBACK;

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
