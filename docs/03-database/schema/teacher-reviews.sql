> Purpose: Tenant schema DDL
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

-- Supabase CLI migration source. Timestamp and lane prefix are assigned in migration-plan.md.
CREATE SCHEMA IF NOT EXISTS private;
CREATE TABLE IF NOT EXISTS public.teacher_reviews(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, teacher_profile_id uuid NOT NULL, reviewer_role text NOT NULL, rating smallint NOT NULL CHECK(rating BETWEEN 1 AND 5), body text, status text NOT NULL DEFAULT 'queued', CONSTRAINT teacher_reviews_pkey PRIMARY KEY(id), CONSTRAINT teacher_reviews_tenant_id_key UNIQUE(university_id,id), CONSTRAINT teacher_reviews_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS teacher_reviews_tenant_created_idx ON public.teacher_reviews(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS teacher_reviews_creator_idx ON public.teacher_reviews(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.teacher_reviews ENABLE ROW LEVEL SECURITY; ALTER TABLE public.teacher_reviews FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_teacher_reviews() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS teacher_reviews_touch ON public.teacher_reviews; CREATE TRIGGER teacher_reviews_touch BEFORE UPDATE ON public.teacher_reviews FOR EACH ROW EXECUTE FUNCTION private.touch_teacher_reviews();
CREATE TABLE IF NOT EXISTS public.teacher_review_authors(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, review_id uuid NOT NULL, author_profile_id uuid NOT NULL, CONSTRAINT teacher_review_authors_pkey PRIMARY KEY(id), CONSTRAINT teacher_review_authors_tenant_id_key UNIQUE(university_id,id), CONSTRAINT teacher_review_authors_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS teacher_review_authors_tenant_created_idx ON public.teacher_review_authors(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS teacher_review_authors_creator_idx ON public.teacher_review_authors(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.teacher_review_authors ENABLE ROW LEVEL SECURITY; ALTER TABLE public.teacher_review_authors FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_teacher_review_authors() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS teacher_review_authors_touch ON public.teacher_review_authors; CREATE TRIGGER teacher_review_authors_touch BEFORE UPDATE ON public.teacher_review_authors FOR EACH ROW EXECUTE FUNCTION private.touch_teacher_review_authors();
-- Rollback only in a later expand/contract migration after consumers and data retention obligations are cleared.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
