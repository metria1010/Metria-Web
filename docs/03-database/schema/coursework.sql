> Purpose: Tenant schema DDL
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

-- Supabase CLI migration source. Timestamp and lane prefix are assigned in migration-plan.md.
CREATE SCHEMA IF NOT EXISTS private;
CREATE TABLE IF NOT EXISTS public.assignments(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, offering_id uuid NOT NULL, title text NOT NULL, description_html text NOT NULL, deadline timestamptz, rubric text, CONSTRAINT assignments_pkey PRIMARY KEY(id), CONSTRAINT assignments_tenant_id_key UNIQUE(university_id,id), CONSTRAINT assignments_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS assignments_tenant_created_idx ON public.assignments(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS assignments_creator_idx ON public.assignments(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.assignments ENABLE ROW LEVEL SECURITY; ALTER TABLE public.assignments FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_assignments() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS assignments_touch ON public.assignments; CREATE TRIGGER assignments_touch BEFORE UPDATE ON public.assignments FOR EACH ROW EXECUTE FUNCTION private.touch_assignments();
CREATE TABLE IF NOT EXISTS public.assignment_guides(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, assignment_id uuid NOT NULL, body_html text NOT NULL, publication_state text NOT NULL DEFAULT 'draft', CONSTRAINT assignment_guides_pkey PRIMARY KEY(id), CONSTRAINT assignment_guides_tenant_id_key UNIQUE(university_id,id), CONSTRAINT assignment_guides_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS assignment_guides_tenant_created_idx ON public.assignment_guides(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS assignment_guides_creator_idx ON public.assignment_guides(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.assignment_guides ENABLE ROW LEVEL SECURITY; ALTER TABLE public.assignment_guides FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_assignment_guides() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS assignment_guides_touch ON public.assignment_guides; CREATE TRIGGER assignment_guides_touch BEFORE UPDATE ON public.assignment_guides FOR EACH ROW EXECUTE FUNCTION private.touch_assignment_guides();
CREATE TABLE IF NOT EXISTS public.submissions(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, assignment_id uuid NOT NULL, student_id uuid NOT NULL, link_url text NOT NULL, submitted_at timestamptz NOT NULL, is_late boolean NOT NULL, review_status text NOT NULL DEFAULT 'pending', feedback text, CONSTRAINT submissions_pkey PRIMARY KEY(id), CONSTRAINT submissions_tenant_id_key UNIQUE(university_id,id), CONSTRAINT submissions_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT, CONSTRAINT submissions_assignment_id_tenant_fk FOREIGN KEY(university_id,assignment_id) REFERENCES public.assignments(university_id,id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS submissions_tenant_created_idx ON public.submissions(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS submissions_creator_idx ON public.submissions(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.submissions ENABLE ROW LEVEL SECURITY; ALTER TABLE public.submissions FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_submissions() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS submissions_touch ON public.submissions; CREATE TRIGGER submissions_touch BEFORE UPDATE ON public.submissions FOR EACH ROW EXECUTE FUNCTION private.touch_submissions();
CREATE TABLE IF NOT EXISTS public.course_info_pages(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, offering_id uuid NOT NULL, body_html text NOT NULL, grading_policy text, CONSTRAINT course_info_pages_pkey PRIMARY KEY(id), CONSTRAINT course_info_pages_tenant_id_key UNIQUE(university_id,id), CONSTRAINT course_info_pages_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS course_info_pages_tenant_created_idx ON public.course_info_pages(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS course_info_pages_creator_idx ON public.course_info_pages(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.course_info_pages ENABLE ROW LEVEL SECURITY; ALTER TABLE public.course_info_pages FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_course_info_pages() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS course_info_pages_touch ON public.course_info_pages; CREATE TRIGGER course_info_pages_touch BEFORE UPDATE ON public.course_info_pages FOR EACH ROW EXECUTE FUNCTION private.touch_course_info_pages();
-- Rollback only in a later expand/contract migration after consumers and data retention obligations are cleared.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
