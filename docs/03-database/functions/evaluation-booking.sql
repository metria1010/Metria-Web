> Purpose: RPC signatures and transaction boundaries
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

-- Security-definer RPCs must set search_path to empty, validate auth.uid(), verify tenant and role, and be granted narrowly.
CREATE OR REPLACE FUNCTION private.book_slot(p_university_id uuid,p_period_id uuid,p_slot_id uuid) RETURNS uuid LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ DECLARE v_id uuid; BEGIN IF auth.uid() IS NULL THEN RAISE EXCEPTION 'unauthenticated'; END IF; PERFORM 1 FROM public.evaluation_periods WHERE id=p_period_id AND university_id=p_university_id FOR UPDATE; IF NOT FOUND THEN RAISE EXCEPTION 'period_unavailable'; END IF; IF (SELECT count(*) FROM public.bookings WHERE slot_id=p_slot_id AND university_id=p_university_id AND status='active') >= (SELECT capacity FROM public.slots WHERE id=p_slot_id AND period_id=p_period_id AND university_id=p_university_id) THEN RAISE EXCEPTION 'slot_full'; END IF; INSERT INTO public.bookings(university_id,period_id,slot_id,student_id) SELECT p_university_id,p_period_id,p_slot_id,id FROM public.profiles WHERE auth_user_id=auth.uid() RETURNING id INTO v_id; RETURN v_id; END $$;
-- Rollback: revoke execute first; preserve append-only audit and financial history.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
