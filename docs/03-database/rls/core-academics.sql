> Purpose: Tenant RLS policies
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

CREATE SCHEMA IF NOT EXISTS private;
CREATE OR REPLACE FUNCTION private.current_university_ids() RETURNS SETOF uuid LANGUAGE sql STABLE SECURITY INVOKER SET search_path= AS $$ SELECT university_id FROM public.university_memberships WHERE profile_id=(SELECT auth.uid()) AND status='active' $$;
CREATE OR REPLACE FUNCTION private.is_platform_admin() RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path= AS $$ SELECT EXISTS(SELECT 1 FROM public.platform_admins WHERE profile_id=(SELECT auth.uid()) AND revoked_at IS NULL) $$;
DROP POLICY IF EXISTS departments_tenant_access ON public.departments;
CREATE POLICY departments_tenant_access ON public.departments FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.departments FROM anon;
DROP POLICY IF EXISTS terms_tenant_access ON public.terms;
CREATE POLICY terms_tenant_access ON public.terms FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.terms FROM anon;
DROP POLICY IF EXISTS courses_tenant_access ON public.courses;
CREATE POLICY courses_tenant_access ON public.courses FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.courses FROM anon;
DROP POLICY IF EXISTS course_offerings_tenant_access ON public.course_offerings;
CREATE POLICY course_offerings_tenant_access ON public.course_offerings FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.course_offerings FROM anon;
DROP POLICY IF EXISTS sections_tenant_access ON public.sections;
CREATE POLICY sections_tenant_access ON public.sections FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.sections FROM anon;
DROP POLICY IF EXISTS enrollments_tenant_access ON public.enrollments;
CREATE POLICY enrollments_tenant_access ON public.enrollments FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.enrollments FROM anon;
DROP POLICY IF EXISTS offering_staff_tenant_access ON public.offering_staff;
CREATE POLICY offering_staff_tenant_access ON public.offering_staff FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.offering_staff FROM anon;
DROP POLICY IF EXISTS grading_scales_tenant_access ON public.grading_scales;
CREATE POLICY grading_scales_tenant_access ON public.grading_scales FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.grading_scales FROM anon;
DROP POLICY IF EXISTS assessments_tenant_access ON public.assessments;
CREATE POLICY assessments_tenant_access ON public.assessments FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.assessments FROM anon;
DROP POLICY IF EXISTS marks_tenant_access ON public.marks;
CREATE POLICY marks_tenant_access ON public.marks FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.marks FROM anon;
DROP POLICY IF EXISTS mark_history_tenant_access ON public.mark_history;
CREATE POLICY mark_history_tenant_access ON public.mark_history FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.mark_history FROM anon;
REVOKE UPDATE,DELETE ON public.mark_history FROM anon,authenticated;
DROP POLICY IF EXISTS import_batches_tenant_access ON public.import_batches;
CREATE POLICY import_batches_tenant_access ON public.import_batches FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.import_batches FROM anon;
DROP POLICY IF EXISTS import_rows_tenant_access ON public.import_rows;
CREATE POLICY import_rows_tenant_access ON public.import_rows FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.import_rows FROM anon;
DROP POLICY IF EXISTS announcements_tenant_access ON public.announcements;
CREATE POLICY announcements_tenant_access ON public.announcements FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.announcements FROM anon;
-- Add narrow per-operation student/staff policies only after identity and role fixtures are defined; no client receives service_role.
REVOKE ALL ON SCHEMA private FROM PUBLIC;

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
