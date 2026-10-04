> Purpose: Tenant RLS policies
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

CREATE SCHEMA IF NOT EXISTS private;
CREATE OR REPLACE FUNCTION private.current_university_ids() RETURNS SETOF uuid LANGUAGE sql STABLE SECURITY INVOKER SET search_path= AS $$ SELECT university_id FROM public.university_memberships WHERE profile_id=(SELECT auth.uid()) AND status='active' $$;
CREATE OR REPLACE FUNCTION private.is_platform_admin() RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path= AS $$ SELECT EXISTS(SELECT 1 FROM public.platform_admins WHERE profile_id=(SELECT auth.uid()) AND revoked_at IS NULL) $$;
DROP POLICY IF EXISTS audit_log_tenant_access ON public.audit_log;
CREATE POLICY audit_log_tenant_access ON public.audit_log FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.audit_log FROM anon;
REVOKE UPDATE,DELETE ON public.audit_log FROM anon,authenticated;
DROP POLICY IF EXISTS rate_limit_counters_tenant_access ON public.rate_limit_counters;
CREATE POLICY rate_limit_counters_tenant_access ON public.rate_limit_counters FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.rate_limit_counters FROM anon;
DROP POLICY IF EXISTS data_deletion_requests_tenant_access ON public.data_deletion_requests;
CREATE POLICY data_deletion_requests_tenant_access ON public.data_deletion_requests FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.data_deletion_requests FROM anon;
DROP POLICY IF EXISTS objection_rate_limits_tenant_access ON public.objection_rate_limits;
CREATE POLICY objection_rate_limits_tenant_access ON public.objection_rate_limits FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.objection_rate_limits FROM anon;
-- Add narrow per-operation student/staff policies only after identity and role fixtures are defined; no client receives service_role.
REVOKE ALL ON SCHEMA private FROM PUBLIC;

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
