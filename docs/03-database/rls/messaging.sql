> Purpose: Tenant RLS policies
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: A
> Last verified against SYMBOL_REGISTRY version: v1

CREATE SCHEMA IF NOT EXISTS private;
CREATE OR REPLACE FUNCTION private.current_university_ids() RETURNS SETOF uuid LANGUAGE sql STABLE SECURITY INVOKER SET search_path= AS $$ SELECT university_id FROM public.university_memberships WHERE profile_id=(SELECT auth.uid()) AND status='active' $$;
CREATE OR REPLACE FUNCTION private.is_platform_admin() RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path= AS $$ SELECT EXISTS(SELECT 1 FROM public.platform_admins WHERE profile_id=(SELECT auth.uid()) AND revoked_at IS NULL) $$;
DROP POLICY IF EXISTS conversations_tenant_access ON public.conversations;
CREATE POLICY conversations_tenant_access ON public.conversations FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.conversations FROM anon;
DROP POLICY IF EXISTS conversation_participants_tenant_access ON public.conversation_participants;
CREATE POLICY conversation_participants_tenant_access ON public.conversation_participants FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.conversation_participants FROM anon;
DROP POLICY IF EXISTS messages_tenant_access ON public.messages;
CREATE POLICY messages_tenant_access ON public.messages FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.messages FROM anon;
DROP POLICY IF EXISTS blocks_tenant_access ON public.blocks;
CREATE POLICY blocks_tenant_access ON public.blocks FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.blocks FROM anon;
DROP POLICY IF EXISTS mutes_tenant_access ON public.mutes;
CREATE POLICY mutes_tenant_access ON public.mutes FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.mutes FROM anon;
DROP POLICY IF EXISTS reports_tenant_access ON public.reports;
CREATE POLICY reports_tenant_access ON public.reports FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.reports FROM anon;
DROP POLICY IF EXISTS moderation_actions_tenant_access ON public.moderation_actions;
CREATE POLICY moderation_actions_tenant_access ON public.moderation_actions FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.moderation_actions FROM anon;
DROP POLICY IF EXISTS bans_tenant_access ON public.bans;
CREATE POLICY bans_tenant_access ON public.bans FOR ALL TO authenticated USING (private.is_platform_admin()) WITH CHECK (private.is_platform_admin());
REVOKE ALL ON public.bans FROM anon;
-- Add narrow per-operation student/staff policies only after identity and role fixtures are defined; no client receives service_role.
REVOKE ALL ON SCHEMA private FROM PUBLIC;

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
