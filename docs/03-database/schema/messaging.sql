> Purpose: Tenant schema DDL
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

-- Supabase CLI migration source. Timestamp and lane prefix are assigned in migration-plan.md.
CREATE SCHEMA IF NOT EXISTS private;
CREATE TABLE IF NOT EXISTS public.conversations(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, kind text NOT NULL CHECK(kind IN ('direct','section_group')), section_id uuid, announce_only boolean NOT NULL DEFAULT false, CONSTRAINT conversations_pkey PRIMARY KEY(id), CONSTRAINT conversations_tenant_id_key UNIQUE(university_id,id), CONSTRAINT conversations_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS conversations_tenant_created_idx ON public.conversations(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS conversations_creator_idx ON public.conversations(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY; ALTER TABLE public.conversations FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_conversations() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS conversations_touch ON public.conversations; CREATE TRIGGER conversations_touch BEFORE UPDATE ON public.conversations FOR EACH ROW EXECUTE FUNCTION private.touch_conversations();
CREATE TABLE IF NOT EXISTS public.conversation_participants(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, conversation_id uuid NOT NULL, profile_id uuid NOT NULL, last_read_at timestamptz, CONSTRAINT conversation_participants_pkey PRIMARY KEY(id), CONSTRAINT conversation_participants_tenant_id_key UNIQUE(university_id,id), CONSTRAINT conversation_participants_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS conversation_participants_tenant_created_idx ON public.conversation_participants(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS conversation_participants_creator_idx ON public.conversation_participants(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.conversation_participants ENABLE ROW LEVEL SECURITY; ALTER TABLE public.conversation_participants FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_conversation_participants() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS conversation_participants_touch ON public.conversation_participants; CREATE TRIGGER conversation_participants_touch BEFORE UPDATE ON public.conversation_participants FOR EACH ROW EXECUTE FUNCTION private.touch_conversation_participants();
CREATE TABLE IF NOT EXISTS public.messages(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, conversation_id uuid NOT NULL, author_id uuid NOT NULL, body text NOT NULL, links text[] NOT NULL DEFAULT ARRAY[]::text[], deleted_at timestamptz, CONSTRAINT messages_pkey PRIMARY KEY(id), CONSTRAINT messages_tenant_id_key UNIQUE(university_id,id), CONSTRAINT messages_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT, CONSTRAINT messages_conversation_id_tenant_fk FOREIGN KEY(university_id,conversation_id) REFERENCES public.conversations(university_id,id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS messages_tenant_created_idx ON public.messages(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS messages_creator_idx ON public.messages(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY; ALTER TABLE public.messages FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_messages() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS messages_touch ON public.messages; CREATE TRIGGER messages_touch BEFORE UPDATE ON public.messages FOR EACH ROW EXECUTE FUNCTION private.touch_messages();
CREATE TABLE IF NOT EXISTS public.blocks(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, blocker_id uuid NOT NULL, blocked_id uuid NOT NULL, CONSTRAINT blocks_pkey PRIMARY KEY(id), CONSTRAINT blocks_tenant_id_key UNIQUE(university_id,id), CONSTRAINT blocks_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS blocks_tenant_created_idx ON public.blocks(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS blocks_creator_idx ON public.blocks(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.blocks ENABLE ROW LEVEL SECURITY; ALTER TABLE public.blocks FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_blocks() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS blocks_touch ON public.blocks; CREATE TRIGGER blocks_touch BEFORE UPDATE ON public.blocks FOR EACH ROW EXECUTE FUNCTION private.touch_blocks();
CREATE TABLE IF NOT EXISTS public.mutes(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, profile_id uuid NOT NULL, muted_by uuid NOT NULL, reason text, CONSTRAINT mutes_pkey PRIMARY KEY(id), CONSTRAINT mutes_tenant_id_key UNIQUE(university_id,id), CONSTRAINT mutes_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS mutes_tenant_created_idx ON public.mutes(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS mutes_creator_idx ON public.mutes(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.mutes ENABLE ROW LEVEL SECURITY; ALTER TABLE public.mutes FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_mutes() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS mutes_touch ON public.mutes; CREATE TRIGGER mutes_touch BEFORE UPDATE ON public.mutes FOR EACH ROW EXECUTE FUNCTION private.touch_mutes();
CREATE TABLE IF NOT EXISTS public.reports(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, reporter_id uuid NOT NULL, target_type text NOT NULL, target_id uuid NOT NULL, reason text NOT NULL, status text NOT NULL DEFAULT 'queued', CONSTRAINT reports_pkey PRIMARY KEY(id), CONSTRAINT reports_tenant_id_key UNIQUE(university_id,id), CONSTRAINT reports_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS reports_tenant_created_idx ON public.reports(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS reports_creator_idx ON public.reports(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY; ALTER TABLE public.reports FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_reports() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS reports_touch ON public.reports; CREATE TRIGGER reports_touch BEFORE UPDATE ON public.reports FOR EACH ROW EXECUTE FUNCTION private.touch_reports();
CREATE TABLE IF NOT EXISTS public.moderation_actions(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, report_id uuid, moderator_id uuid NOT NULL, action text NOT NULL, appeal_note text, CONSTRAINT moderation_actions_pkey PRIMARY KEY(id), CONSTRAINT moderation_actions_tenant_id_key UNIQUE(university_id,id), CONSTRAINT moderation_actions_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS moderation_actions_tenant_created_idx ON public.moderation_actions(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS moderation_actions_creator_idx ON public.moderation_actions(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.moderation_actions ENABLE ROW LEVEL SECURITY; ALTER TABLE public.moderation_actions FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_moderation_actions() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS moderation_actions_touch ON public.moderation_actions; CREATE TRIGGER moderation_actions_touch BEFORE UPDATE ON public.moderation_actions FOR EACH ROW EXECUTE FUNCTION private.touch_moderation_actions();
CREATE TABLE IF NOT EXISTS public.bans(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, profile_id uuid NOT NULL, reason text NOT NULL, starts_at timestamptz NOT NULL, ends_at timestamptz, CONSTRAINT bans_pkey PRIMARY KEY(id), CONSTRAINT bans_tenant_id_key UNIQUE(university_id,id), CONSTRAINT bans_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS bans_tenant_created_idx ON public.bans(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS bans_creator_idx ON public.bans(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.bans ENABLE ROW LEVEL SECURITY; ALTER TABLE public.bans FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_bans() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS bans_touch ON public.bans; CREATE TRIGGER bans_touch BEFORE UPDATE ON public.bans FOR EACH ROW EXECUTE FUNCTION private.touch_bans();
-- Rollback only in a later expand/contract migration after consumers and data retention obligations are cleared.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
