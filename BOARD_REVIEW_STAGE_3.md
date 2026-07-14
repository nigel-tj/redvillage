# Red Village — Revamp Board Review: Stage 3 (Migration Integrity)

**Date:** 2026-07-14
**Scope:** Repair corrupted migrations; prove clean from-scratch migration; regenerate schema.
**Method:** 6-persona hostile review + runtime proof (destructive `db:drop db:create db:migrate`, user-authorized).

## What was done
- **57 corrupted migrations repaired:**
  - 55 with a duplicated first line (`class X < ActiveRecord::Migration[7.2]` twice).
  - 2 with a broken prepended stub over the correct impl (`20150908080417_drop_users`, `20160317085811_add_category_to_artists`).
- **Parse verification:** Ripper check in-container → 97/97 migrations parse, 0 syntax errors.
- **Real schema bug found & fixed:** `20251102163600_create_ads.rb` declared `t.integer :ad_spot_id` while `ad_spots.id` is bigint → FK type mismatch (`Mysql2::Error ... incompatible`, `ActiveRecord::MismatchedForeignKey`). Changed to `t.bigint`. This was **masked by the old `db:schema:load`** and only surfaced on a true from-scratch migrate — vindicates the destructive-reset decision.
- **Audited all other FKs:** every other foreign key uses `t.references`/`add_reference` (auto-bigint) → no further mismatches.

## Runtime evidence
- `db:drop db:create db:migrate` → **EXIT=0, 97/97 migrated.**
- `db/schema.rb` regenerated: `version: 2025_11_02_185734`, 35 tables.
- App boots on fresh empty DB: `/`, `/events`, `/stores`, `/music` all HTTP 200.
- Disk: 8.6 GB free (reset negligible); ~500 MB reclaimed earlier via image/build prune.

## Persona Verdicts
1. **DB/Migrations Engineer — APPROVE.** From-scratch migrate is now the source of truth and it's green. The bigint FK fix is correct and the from-scratch run is the right proof. Schema matches migrations.
2. **Security Engineer — APPROVE.** No security regression; empty DB has no seeded secrets. (Seed hardcoded-password concern deferred to Stage 4.)
3. **QA — CONDITIONAL APPROVE.** Migration integrity proven at runtime. Standing C2 (broken test harness / `minitest/rails`) still open — no automated coverage. Must clear before production.
4. **DevOps/Reliability — APPROVE.** Deterministic DB build restored → reproducible environments/CI now possible. Disk watched per user directive; reclamation offered. Note: 6 GB tagged images reclaimable with `docker image prune -a` (pending user OK).
5. **Rails Architect — APPROVE.** Migrations idempotent-friendly (up/down guards intact on repaired files). schema.rb is now authoritative.
6. **Code Quality — APPROVE.** Corruption fully removed; no dead duplicate class defs remain.

## Board Verdict: **APPROVED to proceed to Stage 4**
6/6 approve (1 CONDITIONAL, 0 BLOCKER).

**Carried obligations:** C2 (test harness + coverage, Stage 5); seed password hardening (Stage 4); optional `docker image prune -a` for 6 GB (user OK).
