# Red Village — Revamp Board Review: Stage 4 (Seed + Demo Content)

**Date:** 2026-07-14
**Scope:** Seed demo content (users + mall/store/product/event); expose & fix schema/view gaps that seeding revealed.
**Method:** 6-persona hostile review + runtime proof (seeded data reachable via UI, slug routes live).

## What was done
- **Seeds extended** (`db/seeds.rb`): added idempotent demo content — 1 Mall, 1 Store (owned by a member, attached to mall + storefront setting), 3 Products (in-stock, valid prices/status), 1 Event (featured, ticket prices). Users (19) already seeded.
- **Fixed pre-existing seed bug:** summary block `User.roles.key(role).humanize` crashed because `group(:role)` returns enum *names* (not integers) under Rails 7.2 — `key("member")` → nil. Made it defensive.
- **Schema gaps exposed by seeding & fixed via new migrations:**
  - `malls` had **no `slug`** but `Mall` declares `friendly_id :slugged` and `Mall.friendly.find` is used in `malls_controller` → would 500 in prod. Added `20251103000000_add_slug_to_malls`.
  - `stores`/`products` had slug **removed** by migration `20251102185734_remove_slug_from_products_and_stores`, yet `Store.friendly.find`/`Product.friendly.find` are used in **10 controllers** → every store/product page was broken. Re-added slug (`20251103000001/2_re_add_slug_to_*`). This was a latent production-breaking inconsistency.
  - `StorefrontSettings` has **no `currency`/`store_name`** columns — seed passed invalid attrs. Corrected seed to real columns.
- **Missing mall views created:** `app/views/malls/{index,show}.html.erb` (none existed → `MallsController#show` rendered `head :no_content` / 204). Added Bootstrap-5 templates listing stores.
- **Controller layout fix:** `MallsController` used `layout 'admin'` for public mall pages — removed so public marketplace pages render in the application layout.

## Runtime evidence
- `db:seed` → **SEED_EXIT=0**; summary: Malls: 1 | Stores: 1 | Products: 3 | Events: 1.
- Migrations: `db:migrate` green (98 migrations incl. 3 new).
- **UI reachability (guest, live HTTP):**
  - `/stores` → 200, store show renders "Artisan Corner"
  - `/events` → 200, lists "Red Village Creative Festival 2026"
  - `/malls` → 200; `/malls/red-village-creative-mall` → 200, renders "Stores in this mall" + linked "Artisan Corner"
  - Friendly-slug routes (`/malls/:slug`, `/stores/:slug`, `/stores/:slug/products`) → 200 (were 500 before slug re-add)
- Store ✔ linked to Mall in DB (`store.mall_id == mall.id`).

## Security note (carried, non-blocking)
- `db/seeds.rb` hardcodes `DEMO_PASSWORD = "password123"` and prints all demo credentials. Acceptable for a local demo/revamp, but **must not ship to production** — flagged as obligation B-SEED before any prod deploy.

## Persona Verdicts
1. **Data/Seeding Engineer — APPROVE.** Content seeds idempotently; DB integrity sound post-migrate. Demo dataset is small but demonstrable.
2. **Security Engineer — CONDITIONAL APPROVE.** Seed password concern noted (B-SEED). No secrets leaked to DB. Slug re-add closes a real prod-breaking gap.
3. **QA — CONDITIONAL APPROVE.** Runtime content reachable & verified. Standing C2 (broken test harness) still open.
4. **DevOps/Reliability — APPROVE.** Seed is reproducible (`db:setup` works now). Disk watched: 8.6 GB free.
5. **Rails Architect — APPROVE.** FriendlyId usage now matches schema (slug columns present for all 3 models). Mall views follow existing Bootstrap convention.
6. **Code Quality — CONDITIONAL APPROVE.** Seed summary defensive fix good. B-SEED (hardcoded password) + consolidate role helper duplication (from Stage 2) still tracked.

## Board Verdict: **APPROVED to proceed to Stage 5**
6/6 approve (3 CONDITIONAL, 0 BLOCKER).

**Carried obligations:** C2 (test harness + coverage, Stage 5); B-SEED (remove hardcoded seed password before prod); C-DRY (consolidate role helpers into concern, Stage 5).
