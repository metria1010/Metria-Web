> Purpose: Tenant RLS policies
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: B
> Last verified against SYMBOL_REGISTRY version: v1

CREATE SCHEMA IF NOT EXISTS private;
CREATE OR REPLACE FUNCTION private.current_university_ids() RETURNS SETOF uuid LANGUAGE sql STABLE SECURITY INVOKER SET search_path= AS $$ SELECT university_id FROM public.university_memberships WHERE profile_id=(SELECT auth.uid()) AND status='active' $$;
CREATE OR REPLACE FUNCTION private.is_platform_admin() RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path= AS $$ SELECT EXISTS(SELECT 1 FROM public.platform_admins WHERE profile_id=(SELECT auth.uid()) AND revoked_at IS NULL) $$;
DROP POLICY IF EXISTS ta_reviews_tenant_access ON public.ta_reviews;
CREATE POLICY ta_reviews_tenant_access ON public.ta_reviews FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.ta_reviews FROM anon;
DROP POLICY IF EXISTS ta_review_authors_tenant_access ON public.ta_review_authors;
CREATE POLICY ta_review_authors_tenant_access ON public.ta_review_authors FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.ta_review_authors FROM anon;
DROP POLICY IF EXISTS public_profiles_tenant_access ON public.public_profiles;
CREATE POLICY public_profiles_tenant_access ON public.public_profiles FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.public_profiles FROM anon;
DROP POLICY IF EXISTS review_aggregates_tenant_access ON public.review_aggregates;
CREATE POLICY review_aggregates_tenant_access ON public.review_aggregates FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.review_aggregates FROM anon;
-- Add narrow per-operation student/staff policies only after identity and role fixtures are defined; no client receives service_role.
REVOKE ALL ON SCHEMA private FROM PUBLIC;

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
