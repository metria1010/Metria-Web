> Purpose: Tenant schema DDL
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

-- Supabase CLI migration source. Timestamp and lane prefix are assigned in migration-plan.md.
CREATE SCHEMA IF NOT EXISTS private;
CREATE TABLE IF NOT EXISTS public.ta_reviews(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, subject_profile_id uuid NOT NULL, rating smallint NOT NULL CHECK(rating BETWEEN 1 AND 5), body text, status text NOT NULL DEFAULT 'queued', CONSTRAINT ta_reviews_pkey PRIMARY KEY(id), CONSTRAINT ta_reviews_tenant_id_key UNIQUE(university_id,id), CONSTRAINT ta_reviews_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS ta_reviews_tenant_created_idx ON public.ta_reviews(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS ta_reviews_creator_idx ON public.ta_reviews(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.ta_reviews ENABLE ROW LEVEL SECURITY; ALTER TABLE public.ta_reviews FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_ta_reviews() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS ta_reviews_touch ON public.ta_reviews; CREATE TRIGGER ta_reviews_touch BEFORE UPDATE ON public.ta_reviews FOR EACH ROW EXECUTE FUNCTION private.touch_ta_reviews();
CREATE TABLE IF NOT EXISTS public.ta_review_authors(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, review_id uuid NOT NULL, author_profile_id uuid NOT NULL, CONSTRAINT ta_review_authors_pkey PRIMARY KEY(id), CONSTRAINT ta_review_authors_tenant_id_key UNIQUE(university_id,id), CONSTRAINT ta_review_authors_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS ta_review_authors_tenant_created_idx ON public.ta_review_authors(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS ta_review_authors_creator_idx ON public.ta_review_authors(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.ta_review_authors ENABLE ROW LEVEL SECURITY; ALTER TABLE public.ta_review_authors FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_ta_review_authors() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS ta_review_authors_touch ON public.ta_review_authors; CREATE TRIGGER ta_review_authors_touch BEFORE UPDATE ON public.ta_review_authors FOR EACH ROW EXECUTE FUNCTION private.touch_ta_review_authors();
CREATE TABLE IF NOT EXISTS public.public_profiles(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, profile_id uuid NOT NULL, publication_state text NOT NULL DEFAULT 'draft', bio text, CONSTRAINT public_profiles_pkey PRIMARY KEY(id), CONSTRAINT public_profiles_tenant_id_key UNIQUE(university_id,id), CONSTRAINT public_profiles_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS public_profiles_tenant_created_idx ON public.public_profiles(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS public_profiles_creator_idx ON public.public_profiles(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.public_profiles ENABLE ROW LEVEL SECURITY; ALTER TABLE public.public_profiles FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_public_profiles() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS public_profiles_touch ON public.public_profiles; CREATE TRIGGER public_profiles_touch BEFORE UPDATE ON public.public_profiles FOR EACH ROW EXECUTE FUNCTION private.touch_public_profiles();
CREATE TABLE IF NOT EXISTS public.review_aggregates(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, subject_profile_id uuid NOT NULL, review_kind text NOT NULL, review_count integer NOT NULL, rating_average numeric(3,2), CONSTRAINT review_aggregates_pkey PRIMARY KEY(id), CONSTRAINT review_aggregates_tenant_id_key UNIQUE(university_id,id), CONSTRAINT review_aggregates_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS review_aggregates_tenant_created_idx ON public.review_aggregates(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS review_aggregates_creator_idx ON public.review_aggregates(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.review_aggregates ENABLE ROW LEVEL SECURITY; ALTER TABLE public.review_aggregates FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_review_aggregates() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS review_aggregates_touch ON public.review_aggregates; CREATE TRIGGER review_aggregates_touch BEFORE UPDATE ON public.review_aggregates FOR EACH ROW EXECUTE FUNCTION private.touch_review_aggregates();
-- Rollback only in a later expand/contract migration after consumers and data retention obligations are cleared.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
