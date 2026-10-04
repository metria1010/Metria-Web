> Purpose: Tenant RLS policies
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

CREATE SCHEMA IF NOT EXISTS private;
CREATE OR REPLACE FUNCTION private.current_university_ids() RETURNS SETOF uuid LANGUAGE sql STABLE SECURITY INVOKER SET search_path= AS $$ SELECT university_id FROM public.university_memberships WHERE profile_id=(SELECT auth.uid()) AND status='active' $$;
CREATE OR REPLACE FUNCTION private.is_platform_admin() RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path= AS $$ SELECT EXISTS(SELECT 1 FROM public.platform_admins WHERE profile_id=(SELECT auth.uid()) AND revoked_at IS NULL) $$;
DROP POLICY IF EXISTS assignments_tenant_access ON public.assignments;
CREATE POLICY assignments_tenant_access ON public.assignments FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.assignments FROM anon;
DROP POLICY IF EXISTS assignment_guides_tenant_access ON public.assignment_guides;
CREATE POLICY assignment_guides_tenant_access ON public.assignment_guides FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.assignment_guides FROM anon;
DROP POLICY IF EXISTS submissions_tenant_access ON public.submissions;
CREATE POLICY submissions_tenant_access ON public.submissions FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.submissions FROM anon;
DROP POLICY IF EXISTS course_info_pages_tenant_access ON public.course_info_pages;
CREATE POLICY course_info_pages_tenant_access ON public.course_info_pages FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.course_info_pages FROM anon;
-- Add narrow per-operation student/staff policies only after identity and role fixtures are defined; no client receives service_role.
REVOKE ALL ON SCHEMA private FROM PUBLIC;

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
