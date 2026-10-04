> Purpose: Tenant schema DDL
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

-- Supabase CLI migration source. Timestamp and lane prefix are assigned in migration-plan.md.
CREATE SCHEMA IF NOT EXISTS private;
CREATE TABLE IF NOT EXISTS public.audit_log(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, actor_id uuid, event_type text NOT NULL, target_type text NOT NULL, target_id uuid, payload jsonb NOT NULL, CONSTRAINT audit_log_pkey PRIMARY KEY(id), CONSTRAINT audit_log_tenant_id_key UNIQUE(university_id,id), CONSTRAINT audit_log_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS audit_log_tenant_created_idx ON public.audit_log(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS audit_log_creator_idx ON public.audit_log(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY; ALTER TABLE public.audit_log FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_audit_log() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS audit_log_touch ON public.audit_log; CREATE TRIGGER audit_log_touch BEFORE UPDATE ON public.audit_log FOR EACH ROW EXECUTE FUNCTION private.touch_audit_log();
CREATE TABLE IF NOT EXISTS public.rate_limit_counters(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, bucket_key text NOT NULL, window_start timestamptz NOT NULL, request_count integer NOT NULL DEFAULT 0, CONSTRAINT rate_limit_counters_pkey PRIMARY KEY(id), CONSTRAINT rate_limit_counters_tenant_id_key UNIQUE(university_id,id), CONSTRAINT rate_limit_counters_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS rate_limit_counters_tenant_created_idx ON public.rate_limit_counters(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS rate_limit_counters_creator_idx ON public.rate_limit_counters(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.rate_limit_counters ENABLE ROW LEVEL SECURITY; ALTER TABLE public.rate_limit_counters FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_rate_limit_counters() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS rate_limit_counters_touch ON public.rate_limit_counters; CREATE TRIGGER rate_limit_counters_touch BEFORE UPDATE ON public.rate_limit_counters FOR EACH ROW EXECUTE FUNCTION private.touch_rate_limit_counters();
CREATE TABLE IF NOT EXISTS public.data_deletion_requests(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, profile_id uuid NOT NULL, status text NOT NULL DEFAULT 'pending', requested_at timestamptz NOT NULL, CONSTRAINT data_deletion_requests_pkey PRIMARY KEY(id), CONSTRAINT data_deletion_requests_tenant_id_key UNIQUE(university_id,id), CONSTRAINT data_deletion_requests_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS data_deletion_requests_tenant_created_idx ON public.data_deletion_requests(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS data_deletion_requests_creator_idx ON public.data_deletion_requests(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.data_deletion_requests ENABLE ROW LEVEL SECURITY; ALTER TABLE public.data_deletion_requests FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_data_deletion_requests() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS data_deletion_requests_touch ON public.data_deletion_requests; CREATE TRIGGER data_deletion_requests_touch BEFORE UPDATE ON public.data_deletion_requests FOR EACH ROW EXECUTE FUNCTION private.touch_data_deletion_requests();
CREATE TABLE IF NOT EXISTS public.objection_rate_limits(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, profile_id uuid NOT NULL, assessment_id uuid NOT NULL, window_start timestamptz NOT NULL, request_count integer NOT NULL DEFAULT 0, CONSTRAINT objection_rate_limits_pkey PRIMARY KEY(id), CONSTRAINT objection_rate_limits_tenant_id_key UNIQUE(university_id,id), CONSTRAINT objection_rate_limits_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS objection_rate_limits_tenant_created_idx ON public.objection_rate_limits(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS objection_rate_limits_creator_idx ON public.objection_rate_limits(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.objection_rate_limits ENABLE ROW LEVEL SECURITY; ALTER TABLE public.objection_rate_limits FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_objection_rate_limits() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS objection_rate_limits_touch ON public.objection_rate_limits; CREATE TRIGGER objection_rate_limits_touch BEFORE UPDATE ON public.objection_rate_limits FOR EACH ROW EXECUTE FUNCTION private.touch_objection_rate_limits();
-- Rollback only in a later expand/contract migration after consumers and data retention obligations are cleared.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
