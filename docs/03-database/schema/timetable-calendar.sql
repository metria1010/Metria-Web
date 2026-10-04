> Purpose: Tenant schema DDL
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

-- Supabase CLI migration source. Timestamp and lane prefix are assigned in migration-plan.md.
CREATE SCHEMA IF NOT EXISTS private;
CREATE TABLE IF NOT EXISTS public.timetable_entries(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, profile_id uuid NOT NULL, title text NOT NULL, starts_at timestamptz NOT NULL, ends_at timestamptz, recurrence_rule text, CONSTRAINT timetable_entries_pkey PRIMARY KEY(id), CONSTRAINT timetable_entries_tenant_id_key UNIQUE(university_id,id), CONSTRAINT timetable_entries_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS timetable_entries_tenant_created_idx ON public.timetable_entries(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS timetable_entries_creator_idx ON public.timetable_entries(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.timetable_entries ENABLE ROW LEVEL SECURITY; ALTER TABLE public.timetable_entries FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_timetable_entries() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS timetable_entries_touch ON public.timetable_entries; CREATE TRIGGER timetable_entries_touch BEFORE UPDATE ON public.timetable_entries FOR EACH ROW EXECUTE FUNCTION private.touch_timetable_entries();
CREATE TABLE IF NOT EXISTS public.calendar_tokens(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, profile_id uuid NOT NULL, token_hash text NOT NULL UNIQUE, expires_at timestamptz, revoked_at timestamptz, CONSTRAINT calendar_tokens_pkey PRIMARY KEY(id), CONSTRAINT calendar_tokens_tenant_id_key UNIQUE(university_id,id), CONSTRAINT calendar_tokens_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS calendar_tokens_tenant_created_idx ON public.calendar_tokens(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS calendar_tokens_creator_idx ON public.calendar_tokens(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.calendar_tokens ENABLE ROW LEVEL SECURITY; ALTER TABLE public.calendar_tokens FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_calendar_tokens() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS calendar_tokens_touch ON public.calendar_tokens; CREATE TRIGGER calendar_tokens_touch BEFORE UPDATE ON public.calendar_tokens FOR EACH ROW EXECUTE FUNCTION private.touch_calendar_tokens();
CREATE TABLE IF NOT EXISTS public.course_meetings(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, section_id uuid NOT NULL, weekday smallint NOT NULL, starts_at time NOT NULL, ends_at time NOT NULL, location text, CONSTRAINT course_meetings_pkey PRIMARY KEY(id), CONSTRAINT course_meetings_tenant_id_key UNIQUE(university_id,id), CONSTRAINT course_meetings_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS course_meetings_tenant_created_idx ON public.course_meetings(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS course_meetings_creator_idx ON public.course_meetings(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.course_meetings ENABLE ROW LEVEL SECURITY; ALTER TABLE public.course_meetings FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_course_meetings() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS course_meetings_touch ON public.course_meetings; CREATE TRIGGER course_meetings_touch BEFORE UPDATE ON public.course_meetings FOR EACH ROW EXECUTE FUNCTION private.touch_course_meetings();
-- Rollback only in a later expand/contract migration after consumers and data retention obligations are cleared.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
