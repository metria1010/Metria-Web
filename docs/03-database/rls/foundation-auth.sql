> Purpose: Tenant RLS policies
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

CREATE SCHEMA IF NOT EXISTS private;
CREATE OR REPLACE FUNCTION private.current_university_ids() RETURNS SETOF uuid LANGUAGE sql STABLE SECURITY INVOKER SET search_path= AS $$ SELECT university_id FROM public.university_memberships WHERE profile_id=(SELECT auth.uid()) AND status='active' $$;
CREATE OR REPLACE FUNCTION private.is_platform_admin() RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path= AS $$ SELECT EXISTS(SELECT 1 FROM public.platform_admins WHERE profile_id=(SELECT auth.uid()) AND revoked_at IS NULL) $$;
DROP POLICY IF EXISTS universities_tenant_access ON public.universities;
CREATE POLICY universities_tenant_access ON public.universities FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.universities FROM anon;
DROP POLICY IF EXISTS university_domains_tenant_access ON public.university_domains;
CREATE POLICY university_domains_tenant_access ON public.university_domains FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.university_domains FROM anon;
DROP POLICY IF EXISTS profiles_tenant_access ON public.profiles;
CREATE POLICY profiles_tenant_access ON public.profiles FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.profiles FROM anon;
DROP POLICY IF EXISTS university_memberships_tenant_access ON public.university_memberships;
CREATE POLICY university_memberships_tenant_access ON public.university_memberships FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.university_memberships FROM anon;
DROP POLICY IF EXISTS roles_tenant_access ON public.roles;
CREATE POLICY roles_tenant_access ON public.roles FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.roles FROM anon;
DROP POLICY IF EXISTS permissions_tenant_access ON public.permissions;
CREATE POLICY permissions_tenant_access ON public.permissions FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.permissions FROM anon;
DROP POLICY IF EXISTS role_permissions_tenant_access ON public.role_permissions;
CREATE POLICY role_permissions_tenant_access ON public.role_permissions FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.role_permissions FROM anon;
DROP POLICY IF EXISTS role_assignments_tenant_access ON public.role_assignments;
CREATE POLICY role_assignments_tenant_access ON public.role_assignments FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.role_assignments FROM anon;
DROP POLICY IF EXISTS role_assignment_history_tenant_access ON public.role_assignment_history;
CREATE POLICY role_assignment_history_tenant_access ON public.role_assignment_history FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.role_assignment_history FROM anon;
REVOKE UPDATE,DELETE ON public.role_assignment_history FROM anon,authenticated;
DROP POLICY IF EXISTS platform_admins_tenant_access ON public.platform_admins;
CREATE POLICY platform_admins_tenant_access ON public.platform_admins FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.platform_admins FROM anon;
DROP POLICY IF EXISTS invites_tenant_access ON public.invites;
CREATE POLICY invites_tenant_access ON public.invites FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.invites FROM anon;
DROP POLICY IF EXISTS platform_settings_tenant_access ON public.platform_settings;
CREATE POLICY platform_settings_tenant_access ON public.platform_settings FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.platform_settings FROM anon;
DROP POLICY IF EXISTS feature_flags_tenant_access ON public.feature_flags;
CREATE POLICY feature_flags_tenant_access ON public.feature_flags FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.feature_flags FROM anon;
-- Add narrow per-operation student/staff policies only after identity and role fixtures are defined; no client receives service_role.
REVOKE ALL ON SCHEMA private FROM PUBLIC;

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
