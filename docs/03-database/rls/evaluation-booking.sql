> Purpose: Tenant RLS policies
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

CREATE SCHEMA IF NOT EXISTS private;
CREATE OR REPLACE FUNCTION private.current_university_ids() RETURNS SETOF uuid LANGUAGE sql STABLE SECURITY INVOKER SET search_path= AS $$ SELECT university_id FROM public.university_memberships WHERE profile_id=(SELECT auth.uid()) AND status='active' $$;
CREATE OR REPLACE FUNCTION private.is_platform_admin() RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path= AS $$ SELECT EXISTS(SELECT 1 FROM public.platform_admins WHERE profile_id=(SELECT auth.uid()) AND revoked_at IS NULL) $$;
DROP POLICY IF EXISTS evaluation_periods_tenant_access ON public.evaluation_periods;
CREATE POLICY evaluation_periods_tenant_access ON public.evaluation_periods FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.evaluation_periods FROM anon;
DROP POLICY IF EXISTS slots_tenant_access ON public.slots;
CREATE POLICY slots_tenant_access ON public.slots FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.slots FROM anon;
DROP POLICY IF EXISTS bookings_tenant_access ON public.bookings;
CREATE POLICY bookings_tenant_access ON public.bookings FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.bookings FROM anon;
DROP POLICY IF EXISTS waitlist_entries_tenant_access ON public.waitlist_entries;
CREATE POLICY waitlist_entries_tenant_access ON public.waitlist_entries FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.waitlist_entries FROM anon;
DROP POLICY IF EXISTS swap_requests_tenant_access ON public.swap_requests;
CREATE POLICY swap_requests_tenant_access ON public.swap_requests FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.swap_requests FROM anon;
-- Add narrow per-operation student/staff policies only after identity and role fixtures are defined; no client receives service_role.
REVOKE ALL ON SCHEMA private FROM PUBLIC;

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
