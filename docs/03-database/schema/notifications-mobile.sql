> Purpose: Tenant schema DDL
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

-- Supabase CLI migration source. Timestamp and lane prefix are assigned in migration-plan.md.
CREATE SCHEMA IF NOT EXISTS private;
CREATE TABLE IF NOT EXISTS public.notification_events(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, event_key text NOT NULL, recipient_id uuid NOT NULL, payload jsonb NOT NULL, dedupe_key text NOT NULL, CONSTRAINT notification_events_pkey PRIMARY KEY(id), CONSTRAINT notification_events_tenant_id_key UNIQUE(university_id,id), CONSTRAINT notification_events_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS notification_events_tenant_created_idx ON public.notification_events(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS notification_events_creator_idx ON public.notification_events(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.notification_events ENABLE ROW LEVEL SECURITY; ALTER TABLE public.notification_events FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_notification_events() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS notification_events_touch ON public.notification_events; CREATE TRIGGER notification_events_touch BEFORE UPDATE ON public.notification_events FOR EACH ROW EXECUTE FUNCTION private.touch_notification_events();
CREATE TABLE IF NOT EXISTS public.notification_deliveries(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, event_id uuid NOT NULL, channel text NOT NULL, status text NOT NULL DEFAULT 'queued', attempts integer NOT NULL DEFAULT 0, next_attempt_at timestamptz, CONSTRAINT notification_deliveries_pkey PRIMARY KEY(id), CONSTRAINT notification_deliveries_tenant_id_key UNIQUE(university_id,id), CONSTRAINT notification_deliveries_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT, CONSTRAINT notification_deliveries_event_id_tenant_fk FOREIGN KEY(university_id,event_id) REFERENCES public.notification_events(university_id,id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS notification_deliveries_tenant_created_idx ON public.notification_deliveries(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS notification_deliveries_creator_idx ON public.notification_deliveries(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.notification_deliveries ENABLE ROW LEVEL SECURITY; ALTER TABLE public.notification_deliveries FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_notification_deliveries() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS notification_deliveries_touch ON public.notification_deliveries; CREATE TRIGGER notification_deliveries_touch BEFORE UPDATE ON public.notification_deliveries FOR EACH ROW EXECUTE FUNCTION private.touch_notification_deliveries();
CREATE TABLE IF NOT EXISTS public.notification_preferences(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, profile_id uuid NOT NULL, channel text NOT NULL, enabled boolean NOT NULL DEFAULT true, quiet_start time, quiet_end time, CONSTRAINT notification_preferences_pkey PRIMARY KEY(id), CONSTRAINT notification_preferences_tenant_id_key UNIQUE(university_id,id), CONSTRAINT notification_preferences_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS notification_preferences_tenant_created_idx ON public.notification_preferences(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS notification_preferences_creator_idx ON public.notification_preferences(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.notification_preferences ENABLE ROW LEVEL SECURITY; ALTER TABLE public.notification_preferences FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_notification_preferences() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS notification_preferences_touch ON public.notification_preferences; CREATE TRIGGER notification_preferences_touch BEFORE UPDATE ON public.notification_preferences FOR EACH ROW EXECUTE FUNCTION private.touch_notification_preferences();
CREATE TABLE IF NOT EXISTS public.push_subscriptions(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, profile_id uuid NOT NULL, endpoint text NOT NULL, key_p256dh text NOT NULL, key_auth text NOT NULL, CONSTRAINT push_subscriptions_pkey PRIMARY KEY(id), CONSTRAINT push_subscriptions_tenant_id_key UNIQUE(university_id,id), CONSTRAINT push_subscriptions_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS push_subscriptions_tenant_created_idx ON public.push_subscriptions(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS push_subscriptions_creator_idx ON public.push_subscriptions(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.push_subscriptions ENABLE ROW LEVEL SECURITY; ALTER TABLE public.push_subscriptions FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_push_subscriptions() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS push_subscriptions_touch ON public.push_subscriptions; CREATE TRIGGER push_subscriptions_touch BEFORE UPDATE ON public.push_subscriptions FOR EACH ROW EXECUTE FUNCTION private.touch_push_subscriptions();
CREATE TABLE IF NOT EXISTS public.email_log(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, delivery_id uuid NOT NULL, provider_message_id text, status text NOT NULL, CONSTRAINT email_log_pkey PRIMARY KEY(id), CONSTRAINT email_log_tenant_id_key UNIQUE(university_id,id), CONSTRAINT email_log_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS email_log_tenant_created_idx ON public.email_log(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS email_log_creator_idx ON public.email_log(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.email_log ENABLE ROW LEVEL SECURITY; ALTER TABLE public.email_log FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_email_log() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS email_log_touch ON public.email_log; CREATE TRIGGER email_log_touch BEFORE UPDATE ON public.email_log FOR EACH ROW EXECUTE FUNCTION private.touch_email_log();
CREATE TABLE IF NOT EXISTS public.outbox_jobs(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, event_type text NOT NULL, payload jsonb NOT NULL, idempotency_key text NOT NULL, status text NOT NULL DEFAULT 'queued', attempts integer NOT NULL DEFAULT 0, next_attempt_at timestamptz, CONSTRAINT outbox_jobs_pkey PRIMARY KEY(id), CONSTRAINT outbox_jobs_tenant_id_key UNIQUE(university_id,id), CONSTRAINT outbox_jobs_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS outbox_jobs_tenant_created_idx ON public.outbox_jobs(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS outbox_jobs_creator_idx ON public.outbox_jobs(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.outbox_jobs ENABLE ROW LEVEL SECURITY; ALTER TABLE public.outbox_jobs FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_outbox_jobs() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS outbox_jobs_touch ON public.outbox_jobs; CREATE TRIGGER outbox_jobs_touch BEFORE UPDATE ON public.outbox_jobs FOR EACH ROW EXECUTE FUNCTION private.touch_outbox_jobs();
CREATE TABLE IF NOT EXISTS public.dead_letters(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, outbox_job_id uuid NOT NULL, failure_reason text NOT NULL, failed_at timestamptz NOT NULL, CONSTRAINT dead_letters_pkey PRIMARY KEY(id), CONSTRAINT dead_letters_tenant_id_key UNIQUE(university_id,id), CONSTRAINT dead_letters_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS dead_letters_tenant_created_idx ON public.dead_letters(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS dead_letters_creator_idx ON public.dead_letters(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.dead_letters ENABLE ROW LEVEL SECURITY; ALTER TABLE public.dead_letters FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_dead_letters() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS dead_letters_touch ON public.dead_letters; CREATE TRIGGER dead_letters_touch BEFORE UPDATE ON public.dead_letters FOR EACH ROW EXECUTE FUNCTION private.touch_dead_letters();
-- Rollback only in a later expand/contract migration after consumers and data retention obligations are cleared.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
