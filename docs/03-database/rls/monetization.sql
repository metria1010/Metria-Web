> Purpose: Tenant RLS policies
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

CREATE SCHEMA IF NOT EXISTS private;
CREATE OR REPLACE FUNCTION private.current_university_ids() RETURNS SETOF uuid LANGUAGE sql STABLE SECURITY INVOKER SET search_path= AS $$ SELECT university_id FROM public.university_memberships WHERE profile_id=(SELECT auth.uid()) AND status='active' $$;
CREATE OR REPLACE FUNCTION private.is_platform_admin() RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path= AS $$ SELECT EXISTS(SELECT 1 FROM public.platform_admins WHERE profile_id=(SELECT auth.uid()) AND revoked_at IS NULL) $$;
DROP POLICY IF EXISTS ad_networks_tenant_access ON public.ad_networks;
CREATE POLICY ad_networks_tenant_access ON public.ad_networks FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.ad_networks FROM anon;
DROP POLICY IF EXISTS ad_formats_tenant_access ON public.ad_formats;
CREATE POLICY ad_formats_tenant_access ON public.ad_formats FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.ad_formats FROM anon;
DROP POLICY IF EXISTS page_types_tenant_access ON public.page_types;
CREATE POLICY page_types_tenant_access ON public.page_types FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.page_types FROM anon;
DROP POLICY IF EXISTS ad_placements_tenant_access ON public.ad_placements;
CREATE POLICY ad_placements_tenant_access ON public.ad_placements FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.ad_placements FROM anon;
DROP POLICY IF EXISTS ad_config_versions_tenant_access ON public.ad_config_versions;
CREATE POLICY ad_config_versions_tenant_access ON public.ad_config_versions FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.ad_config_versions FROM anon;
DROP POLICY IF EXISTS ad_kill_switches_tenant_access ON public.ad_kill_switches;
CREATE POLICY ad_kill_switches_tenant_access ON public.ad_kill_switches FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.ad_kill_switches FROM anon;
DROP POLICY IF EXISTS sponsors_tenant_access ON public.sponsors;
CREATE POLICY sponsors_tenant_access ON public.sponsors FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.sponsors FROM anon;
DROP POLICY IF EXISTS sponsor_creatives_tenant_access ON public.sponsor_creatives;
CREATE POLICY sponsor_creatives_tenant_access ON public.sponsor_creatives FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.sponsor_creatives FROM anon;
DROP POLICY IF EXISTS sponsor_slots_tenant_access ON public.sponsor_slots;
CREATE POLICY sponsor_slots_tenant_access ON public.sponsor_slots FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.sponsor_slots FROM anon;
DROP POLICY IF EXISTS page_visits_raw_tenant_access ON public.page_visits_raw;
CREATE POLICY page_visits_raw_tenant_access ON public.page_visits_raw FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.page_visits_raw FROM anon;
DROP POLICY IF EXISTS page_visits_daily_tenant_access ON public.page_visits_daily;
CREATE POLICY page_visits_daily_tenant_access ON public.page_visits_daily FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.page_visits_daily FROM anon;
DROP POLICY IF EXISTS attribution_rules_tenant_access ON public.attribution_rules;
CREATE POLICY attribution_rules_tenant_access ON public.attribution_rules FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.attribution_rules FROM anon;
DROP POLICY IF EXISTS earnings_entries_tenant_access ON public.earnings_entries;
CREATE POLICY earnings_entries_tenant_access ON public.earnings_entries FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.earnings_entries FROM anon;
DROP POLICY IF EXISTS revenue_share_models_tenant_access ON public.revenue_share_models;
CREATE POLICY revenue_share_models_tenant_access ON public.revenue_share_models FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.revenue_share_models FROM anon;
DROP POLICY IF EXISTS revenue_allocations_tenant_access ON public.revenue_allocations;
CREATE POLICY revenue_allocations_tenant_access ON public.revenue_allocations FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.revenue_allocations FROM anon;
REVOKE UPDATE,DELETE ON public.revenue_allocations FROM anon,authenticated;
DROP POLICY IF EXISTS payout_accounts_tenant_access ON public.payout_accounts;
CREATE POLICY payout_accounts_tenant_access ON public.payout_accounts FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.payout_accounts FROM anon;
DROP POLICY IF EXISTS payouts_tenant_access ON public.payouts;
CREATE POLICY payouts_tenant_access ON public.payouts FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.payouts FROM anon;
DROP POLICY IF EXISTS payout_events_tenant_access ON public.payout_events;
CREATE POLICY payout_events_tenant_access ON public.payout_events FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.payout_events FROM anon;
REVOKE UPDATE,DELETE ON public.payout_events FROM anon,authenticated;
DROP POLICY IF EXISTS ad_impressions_tenant_access ON public.ad_impressions;
CREATE POLICY ad_impressions_tenant_access ON public.ad_impressions FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.ad_impressions FROM anon;
DROP POLICY IF EXISTS consent_records_tenant_access ON public.consent_records;
CREATE POLICY consent_records_tenant_access ON public.consent_records FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.consent_records FROM anon;
-- Add narrow per-operation student/staff policies only after identity and role fixtures are defined; no client receives service_role.
REVOKE ALL ON SCHEMA private FROM PUBLIC;

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
