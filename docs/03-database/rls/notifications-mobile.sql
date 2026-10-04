> Purpose: Tenant RLS policies
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

CREATE SCHEMA IF NOT EXISTS private;
CREATE OR REPLACE FUNCTION private.current_university_ids() RETURNS SETOF uuid LANGUAGE sql STABLE SECURITY INVOKER SET search_path= AS $$ SELECT university_id FROM public.university_memberships WHERE profile_id=(SELECT auth.uid()) AND status='active' $$;
CREATE OR REPLACE FUNCTION private.is_platform_admin() RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path= AS $$ SELECT EXISTS(SELECT 1 FROM public.platform_admins WHERE profile_id=(SELECT auth.uid()) AND revoked_at IS NULL) $$;
DROP POLICY IF EXISTS notification_events_tenant_access ON public.notification_events;
CREATE POLICY notification_events_tenant_access ON public.notification_events FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.notification_events FROM anon;
DROP POLICY IF EXISTS notification_deliveries_tenant_access ON public.notification_deliveries;
CREATE POLICY notification_deliveries_tenant_access ON public.notification_deliveries FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.notification_deliveries FROM anon;
DROP POLICY IF EXISTS notification_preferences_tenant_access ON public.notification_preferences;
CREATE POLICY notification_preferences_tenant_access ON public.notification_preferences FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.notification_preferences FROM anon;
DROP POLICY IF EXISTS push_subscriptions_tenant_access ON public.push_subscriptions;
CREATE POLICY push_subscriptions_tenant_access ON public.push_subscriptions FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.push_subscriptions FROM anon;
DROP POLICY IF EXISTS email_log_tenant_access ON public.email_log;
CREATE POLICY email_log_tenant_access ON public.email_log FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.email_log FROM anon;
DROP POLICY IF EXISTS outbox_jobs_tenant_access ON public.outbox_jobs;
CREATE POLICY outbox_jobs_tenant_access ON public.outbox_jobs FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.outbox_jobs FROM anon;
DROP POLICY IF EXISTS dead_letters_tenant_access ON public.dead_letters;
CREATE POLICY dead_letters_tenant_access ON public.dead_letters FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.dead_letters FROM anon;
-- Add narrow per-operation student/staff policies only after identity and role fixtures are defined; no client receives service_role.
REVOKE ALL ON SCHEMA private FROM PUBLIC;

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
