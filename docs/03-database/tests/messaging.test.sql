> Purpose: pgTAP RLS and schema smoke tests
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(11);
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.conversations'::regclass),'conversations has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.conversation_participants'::regclass),'conversation_participants has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.messages'::regclass),'messages has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.blocks'::regclass),'blocks has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.mutes'::regclass),'mutes has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.reports'::regclass),'reports has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.moderation_actions'::regclass),'moderation_actions has RLS');
SELECT ok((SELECT relrowsecurity FROM pg_class WHERE oid='public.bans'::regclass),'bans has RLS');
SELECT ok(to_regprocedure('private.current_university_ids()') IS NOT NULL,'tenant helper installed');
SELECT ok(NOT has_table_privilege('anon','public.profiles','SELECT'),'anonymous cannot select profiles');
SELECT ok(NOT has_table_privilege('anon','public.marks','SELECT'),'anonymous cannot select marks');
SELECT * FROM finish();
ROLLBACK;

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
