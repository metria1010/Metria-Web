> Purpose: Tenant schema DDL
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

-- Supabase CLI migration source. Timestamp and lane prefix are assigned in migration-plan.md.
CREATE SCHEMA IF NOT EXISTS private;
CREATE TABLE IF NOT EXISTS public.evaluation_periods(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, offering_id uuid NOT NULL, section_id uuid NOT NULL, title text NOT NULL, starts_at timestamptz NOT NULL, ends_at timestamptz NOT NULL, cutoff_hours integer NOT NULL DEFAULT 6, allow_swaps boolean NOT NULL DEFAULT false, CONSTRAINT evaluation_periods_pkey PRIMARY KEY(id), CONSTRAINT evaluation_periods_tenant_id_key UNIQUE(university_id,id), CONSTRAINT evaluation_periods_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT, CONSTRAINT evaluation_periods_offering_id_tenant_fk FOREIGN KEY(university_id,offering_id) REFERENCES public.course_offerings(university_id,id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS evaluation_periods_tenant_created_idx ON public.evaluation_periods(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS evaluation_periods_creator_idx ON public.evaluation_periods(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.evaluation_periods ENABLE ROW LEVEL SECURITY; ALTER TABLE public.evaluation_periods FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_evaluation_periods() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS evaluation_periods_touch ON public.evaluation_periods; CREATE TRIGGER evaluation_periods_touch BEFORE UPDATE ON public.evaluation_periods FOR EACH ROW EXECUTE FUNCTION private.touch_evaluation_periods();
CREATE TABLE IF NOT EXISTS public.slots(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, period_id uuid NOT NULL, starts_at timestamptz NOT NULL, ends_at timestamptz NOT NULL, capacity integer NOT NULL CHECK(capacity>0), location text, CONSTRAINT slots_pkey PRIMARY KEY(id), CONSTRAINT slots_tenant_id_key UNIQUE(university_id,id), CONSTRAINT slots_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT, CONSTRAINT slots_period_id_tenant_fk FOREIGN KEY(university_id,period_id) REFERENCES public.evaluation_periods(university_id,id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS slots_tenant_created_idx ON public.slots(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS slots_creator_idx ON public.slots(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.slots ENABLE ROW LEVEL SECURITY; ALTER TABLE public.slots FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_slots() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS slots_touch ON public.slots; CREATE TRIGGER slots_touch BEFORE UPDATE ON public.slots FOR EACH ROW EXECUTE FUNCTION private.touch_slots();
CREATE TABLE IF NOT EXISTS public.bookings(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, period_id uuid NOT NULL, slot_id uuid NOT NULL, student_id uuid NOT NULL, status text NOT NULL DEFAULT 'active', UNIQUE(university_id,period_id,student_id), CONSTRAINT bookings_pkey PRIMARY KEY(id), CONSTRAINT bookings_tenant_id_key UNIQUE(university_id,id), CONSTRAINT bookings_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT, CONSTRAINT bookings_slot_id_tenant_fk FOREIGN KEY(university_id,slot_id) REFERENCES public.slots(university_id,id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS bookings_tenant_created_idx ON public.bookings(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS bookings_creator_idx ON public.bookings(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY; ALTER TABLE public.bookings FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_bookings() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS bookings_touch ON public.bookings; CREATE TRIGGER bookings_touch BEFORE UPDATE ON public.bookings FOR EACH ROW EXECUTE FUNCTION private.touch_bookings();
CREATE TABLE IF NOT EXISTS public.waitlist_entries(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, slot_id uuid NOT NULL, student_id uuid NOT NULL, position integer NOT NULL, status text NOT NULL DEFAULT 'waiting', CONSTRAINT waitlist_entries_pkey PRIMARY KEY(id), CONSTRAINT waitlist_entries_tenant_id_key UNIQUE(university_id,id), CONSTRAINT waitlist_entries_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS waitlist_entries_tenant_created_idx ON public.waitlist_entries(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS waitlist_entries_creator_idx ON public.waitlist_entries(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.waitlist_entries ENABLE ROW LEVEL SECURITY; ALTER TABLE public.waitlist_entries FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_waitlist_entries() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS waitlist_entries_touch ON public.waitlist_entries; CREATE TRIGGER waitlist_entries_touch BEFORE UPDATE ON public.waitlist_entries FOR EACH ROW EXECUTE FUNCTION private.touch_waitlist_entries();
CREATE TABLE IF NOT EXISTS public.swap_requests(id uuid NOT NULL DEFAULT gen_random_uuid(), university_id uuid NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), created_by uuid, from_booking_id uuid NOT NULL, to_booking_id uuid NOT NULL, requested_by uuid NOT NULL, accepted_by uuid, status text NOT NULL DEFAULT 'pending', CONSTRAINT swap_requests_pkey PRIMARY KEY(id), CONSTRAINT swap_requests_tenant_id_key UNIQUE(university_id,id), CONSTRAINT swap_requests_university_fk FOREIGN KEY(university_id) REFERENCES public.universities(id) ON DELETE RESTRICT);
CREATE INDEX IF NOT EXISTS swap_requests_tenant_created_idx ON public.swap_requests(university_id,created_at DESC);
CREATE INDEX IF NOT EXISTS swap_requests_creator_idx ON public.swap_requests(university_id,created_by) WHERE created_by IS NOT NULL;
ALTER TABLE public.swap_requests ENABLE ROW LEVEL SECURITY; ALTER TABLE public.swap_requests FORCE ROW LEVEL SECURITY;
CREATE OR REPLACE FUNCTION private.touch_swap_requests() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$ BEGIN NEW.updated_at:=now(); RETURN NEW; END $$;
DROP TRIGGER IF EXISTS swap_requests_touch ON public.swap_requests; CREATE TRIGGER swap_requests_touch BEFORE UPDATE ON public.swap_requests FOR EACH ROW EXECUTE FUNCTION private.touch_swap_requests();
-- Rollback only in a later expand/contract migration after consumers and data retention obligations are cleared.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
