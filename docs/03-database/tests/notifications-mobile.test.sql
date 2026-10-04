> Purpose: pgTAP RLS and schema smoke tests
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(10);
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.notification_events'::regclass),'notification_events has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.notification_deliveries'::regclass),'notification_deliveries has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.notification_preferences'::regclass),'notification_preferences has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.push_subscriptions'::regclass),'push_subscriptions has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.email_log'::regclass),'email_log has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.outbox_jobs'::regclass),'outbox_jobs has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.dead_letters'::regclass),'dead_letters has RLS');
SELECT ok(to_regprocedure('private.current_university_ids()') IS NOT NULL,'tenant helper installed');
SELECT ok(NOT has_table_privilege('anon','public.profiles','SELECT'),'anonymous cannot select profiles');
SELECT ok(NOT has_table_privilege('anon','public.marks','SELECT'),'anonymous cannot select marks');
SELECT * FROM finish();
ROLLBACK;

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
