> Purpose: Tenant schema DDL
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

-- Supabase CLI migration source. Timestamp and lane prefix are assigned in migration-plan.md.
CREATE SCHEMA IF NOT EXISTS private;
CREATE TABLE IF NOT EXISTS public.content_pages(id uuid NOT NULL DEFAULT gen_random_uuid(), created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, slug text NOT NULL, title text NOT NULL, body_html text NOT NULL, publication_state text NOT NULL DEFAULT 'draft', published_at timestamptz, CONSTRAINT content_pages_pkey PRIMARY KEY(id), CONSTRAINT content_pages_tenant_id_key UNIQUE(university_id,id), CONSTRAINT content_pages_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS content_pages_tenant_created_idx ON public.content_pages(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS content_pages_creator_idx ON public.content_pages(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.content_pages ENABLE ROW LEVEL SECURITY; ALTER TABLE public.content_pages FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_content_pages() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS content_pages_touch ON public.content_pages; CREATE TRIGGER content_pages_touch BEFORE UPDATE ON public.content_pages FOR EACH ROW EXECUTE FUNCTION private.touch_content_pages();
CREATE TABLE IF NOT EXISTS public.help_articles(id uuid NOT NULL DEFAULT gen_random_uuid(), created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, slug text NOT NULL, title text NOT NULL, body text NOT NULL, publication_state text NOT NULL DEFAULT 'draft', CONSTRAINT help_articles_pkey PRIMARY KEY(id), CONSTRAINT help_articles_tenant_id_key UNIQUE(university_id,id), CONSTRAINT help_articles_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS help_articles_tenant_created_idx ON public.help_articles(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS help_articles_creator_idx ON public.help_articles(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.help_articles ENABLE ROW LEVEL SECURITY; ALTER TABLE public.help_articles FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_help_articles() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS help_articles_touch ON public.help_articles; CREATE TRIGGER help_articles_touch BEFORE UPDATE ON public.help_articles FOR EACH ROW EXECUTE FUNCTION private.touch_help_articles();
CREATE TABLE IF NOT EXISTS public.redirects(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, source_path text NOT NULL, target_path text NOT NULL, status_code integer NOT NULL, CONSTRAINT redirects_pkey PRIMARY KEY(id), CONSTRAINT redirects_tenant_id_key UNIQUE(university_id,id), CONSTRAINT redirects_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS redirects_tenant_created_idx ON public.redirects(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS redirects_creator_idx ON public.redirects(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.redirects ENABLE ROW LEVEL SECURITY; ALTER TABLE public.redirects FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_redirects() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS redirects_touch ON public.redirects; CREATE TRIGGER redirects_touch BEFORE UPDATE ON public.redirects FOR EACH ROW EXECUTE FUNCTION private.touch_redirects();
CREATE TABLE IF NOT EXISTS public.seo_overrides(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, path text NOT NULL, title text, description text, canonical_url text, CONSTRAINT seo_overrides_pkey PRIMARY KEY(id), CONSTRAINT seo_overrides_tenant_id_key UNIQUE(university_id,id), CONSTRAINT seo_overrides_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS seo_overrides_tenant_created_idx ON public.seo_overrides(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS seo_overrides_creator_idx ON public.seo_overrides(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.seo_overrides ENABLE ROW LEVEL SECURITY; ALTER TABLE public.seo_overrides FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_seo_overrides() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS seo_overrides_touch ON public.seo_overrides; CREATE TRIGGER seo_overrides_touch BEFORE UPDATE ON public.seo_overrides FOR EACH ROW EXECUTE FUNCTION private.touch_seo_overrides();
CREATE TABLE IF NOT EXISTS public.calculators(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, key text NOT NULL UNIQUE, title text NOT NULL, schema_version integer NOT NULL, CONSTRAINT calculators_pkey PRIMARY KEY(id), CONSTRAINT calculators_tenant_id_key UNIQUE(university_id,id), CONSTRAINT calculators_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS calculators_tenant_created_idx ON public.calculators(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS calculators_creator_idx ON public.calculators(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.calculators ENABLE ROW LEVEL SECURITY; ALTER TABLE public.calculators FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_calculators() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS calculators_touch ON public.calculators; CREATE TRIGGER calculators_touch BEFORE UPDATE ON public.calculators FOR EACH ROW EXECUTE FUNCTION private.touch_calculators();
-- Rollback only in a later expand/contract migration after consumers and data retention obligations are cleared.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
