> Purpose: Tenant schema DDL
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

-- Supabase CLI migration source. Timestamp and lane prefix are assigned in migration-plan.md.
CREATE SCHEMA IF NOT EXISTS private;
CREATE TABLE IF NOT EXISTS public.objections(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, mark_id uuid NOT NULL, student_id uuid NOT NULL, assigned_to uuid, reason text NOT NULL, attachment_url text, status text NOT NULL DEFAULT 'open', CONSTRAINT objections_pkey PRIMARY KEY(id), CONSTRAINT objections_tenant_id_key UNIQUE(university_id,id), CONSTRAINT objections_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT, CONSTRAINT objections_mark_id_tenant_fk FOREIGN KEY(university_id,mark_id) REFERENCES public.marks(university_id,id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS objections_tenant_created_idx ON public.objections(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS objections_creator_idx ON public.objections(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.objections ENABLE ROW LEVEL SECURITY; ALTER TABLE public.objections FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_objections() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS objections_touch ON public.objections; CREATE TRIGGER objections_touch BEFORE UPDATE ON public.objections FOR EACH ROW EXECUTE FUNCTION private.touch_objections();
CREATE TABLE IF NOT EXISTS public.objection_messages(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, objection_id uuid NOT NULL, author_id uuid NOT NULL, body text NOT NULL, CONSTRAINT objection_messages_pkey PRIMARY KEY(id), CONSTRAINT objection_messages_tenant_id_key UNIQUE(university_id,id), CONSTRAINT objection_messages_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS objection_messages_tenant_created_idx ON public.objection_messages(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS objection_messages_creator_idx ON public.objection_messages(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.objection_messages ENABLE ROW LEVEL SECURITY; ALTER TABLE public.objection_messages FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_objection_messages() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS objection_messages_touch ON public.objection_messages; CREATE TRIGGER objection_messages_touch BEFORE UPDATE ON public.objection_messages FOR EACH ROW EXECUTE FUNCTION private.touch_objection_messages();
-- Rollback only in a later expand/contract migration after consumers and data retention obligations are cleared.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
