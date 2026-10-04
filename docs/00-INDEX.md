> Purpose: Core architecture and execution specification
> Audience: founders and coding agents
> Prerequisites: `docs/00-INDEX.md`, `docs/DECISIONS.md`, `docs/SYMBOL_REGISTRY.md`
> Owner lane: Shared
> Last verified against SYMBOL_REGISTRY version: v1

# Metria Development Plan

## Reading order
1. `DECISIONS.md`, `SYMBOL_REGISTRY.md`, and `TRACEABILITY.md`.
2. Product requirements in `01-product/`.
3. Database contracts in `03-database/` before application work.
4. Architecture, API, frontend, growth, and quality specifications.
5. `08-delivery/` cards in dependency order.
6. Agent setup and operations before staging and launch.

## How to execute with coding agents
Select one card from the dependency graph. Load exactly its context-pack paths, verify the registry, implement only its scope, run the named tests, update registry and traceability if symbols changed, and open a short-lived PR. Do not start lane work until the Phase 0 Foundation Gate passes. Every schema change is a single owned migration and must be communicated before consumers are changed.

## Product boundary
The product is a multi-tenant academic evaluation/coursework platform with a public search and tools layer and authenticated student/TA layer. Ads are configured on both layers, except auth pages which have zero ad scripts. No university affiliation is implied. §15 migration/cleanup is excluded. Native apps and ML prediction are out of scope.

## Glossary
TA = teaching assistant; offering = catalog course in a term; section = group within an offering; evaluation period = time window containing booking slots; lane = founder ownership area; RPC = Postgres function called through Supabase; DLQ = dead-letter queue; k = minimum group size before aggregate publication.

## Self-check
- [x] Header and audience are stated.
- [x] Scope, tests, and operational constraints are present.
