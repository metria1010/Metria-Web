> Purpose: Tenant schema DDL
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

-- Supabase CLI migration source. Timestamp and lane prefix are assigned in migration-plan.md.
CREATE SCHEMA IF NOT EXISTS private;
CREATE TABLE IF NOT EXISTS public.ai_usage(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, profile_id uuid NOT NULL, day date NOT NULL, request_count integer NOT NULL DEFAULT 0, CONSTRAINT ai_usage_pkey PRIMARY KEY(id), CONSTRAINT ai_usage_tenant_id_key UNIQUE(university_id,id), CONSTRAINT ai_usage_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS ai_usage_tenant_created_idx ON public.ai_usage(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS ai_usage_creator_idx ON public.ai_usage(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.ai_usage ENABLE ROW LEVEL SECURITY; ALTER TABLE public.ai_usage FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_ai_usage() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS ai_usage_touch ON public.ai_usage; CREATE TRIGGER ai_usage_touch BEFORE UPDATE ON public.ai_usage FOR EACH ROW EXECUTE FUNCTION private.touch_ai_usage();
-- Rollback only in a later expand/contract migration after consumers and data retention obligations are cleared.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
