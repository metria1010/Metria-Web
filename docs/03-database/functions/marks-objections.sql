> Purpose: RPC signatures and transaction boundaries
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

-- Security-definer RPCs must set search_path to empty, validate auth.uid(), verify tenant and role, and be granted narrowly.
CREATE OR REPLACE FUNCTION private.change_mark_from_objection(p_objection_id uuid,p_new_score numeric,p_reason text) RETURNS uuid LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$ DECLARE v_mark public.marks%ROWTYPE; BEGIN IF auth.uid() IS NULL THEN RAISE EXCEPTION 'unauthenticated'; END IF; SELECT m.* INTO v_mark FROM public.objections o JOIN public.marks m ON m.id=o.mark_id AND m.university_id=o.university_id WHERE o.id=p_objection_id FOR UPDATE OF m; IF NOT FOUND THEN RAISE EXCEPTION 'objection_unavailable'; END IF; INSERT INTO public.mark_history(university_id,mark_id,actor_id,old_score,new_score,reason,source) VALUES(v_mark.university_id,v_mark.id,auth.uid(),v_mark.score,p_new_score,p_reason,'objection'); UPDATE public.marks SET score=p_new_score WHERE id=v_mark.id; INSERT INTO public.audit_log(university_id,actor_id,event_type,target_type,target_id,payload) VALUES(v_mark.university_id,auth.uid(),'mark.changed','mark',v_mark.id,jsonb_build_object('objection_id',p_objection_id)); UPDATE public.objections SET status='resolved' WHERE id=p_objection_id; RETURN v_mark.id; END $$;
-- Rollback: revoke execute first; preserve append-only audit and financial history.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
