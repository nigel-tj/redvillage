# Red Village — Running App: Multi-Persona Board Review + Issue Log + Improvements

> **Superseded:** This running-log is historical. Authoritative sign-off is [BOARD_REVIEW_STAGE_6_FINAL.md](BOARD_REVIEW_STAGE_6_FINAL.md) (APPROVED FOR COMMIT). Issues listed below as OPEN for B7 (migrations) and B9/F1 (public auth) were fixed in Stages 1–3; do not reopen them from this file.

**Date:** 2026-07-14
**Status:** App is RUNNING locally (HTTP 200 on :3000). Boot path repaired; core flows verified.
**Method:** 6 expert personas, each reviews the live app + source at file:line. Verdicts: APPROVE / CONDITIONAL / BLOCKER.

---

## 0. Boot / Run Verification (ground truth, live)
- `GET /` → 200 (VisitorsController#index, 19 seeded users, DB queries OK)
- Auth: `admin@redvillage.test` / `password123` logs in → `/admin/dashboard` 200
- All role dashboards 200: admin, member, dj, artist, photographer, videographer, curator, designer, editor
- `/events` `/news` `/music` `/gallery` `/stores` `/contact_us` `/coming_soon` `/ticket_listings` → 200 (authed)
- NO 500s in logs after slug fix
- Known-good fixes already applied (see §3)

---

## PERSONA 1 — Backend / Rails Integrity Engineer
**Verdict: CONDITIONAL — running, but structural debt remains.**

Issues found (file:line):
- **B1 (BLOCKER, discovered & FIXED):** `Gemfile` lacked `mysql2`; dev pinned `sqlite3` → `db:create` failed ("mysql2 is not part of the bundle"). FIXED: added `gem 'mysql2', '~> 0.5'`, removed sqlite3, regenerated `Gemfile.lock`.
- **B2 (FIXED):** `config/database.yml` dev/test → sqlite3. Repointed to mysql.
- **B3 (FIXED):** `db/schema.rb` Rails 7.2 bigint-PK FK mismatch — 38 `*_id` integer cols + `ads.ad_spot_id` int vs `ad_spots.id` bigint → MySQL errno 3780. FIXED via sed integer→bigint (single-file, reversible).
- **B4 (FIXED):** `artists` table absent from `schema.rb` (migration corrupted) → `Artist.count` 500 on admin dashboard. FIXED: added table def + DDL.
- **B5 (FIXED):** `main_banners` missing `created_at`/`updated_at` → `/designer/dashboard` 500. FIXED.
- **B6 (FIXED):** `Store`/`Product`/`Mall` (FriendlyId) missing `slug` column → `/stores/1` 500 "Unknown column stores.slug". FIXED: added slug to schema.rb + live DB.
- **B7 (OPEN, needs consent):** 76 migration files have duplicated `class X < ActiveRecord::Migration[7.2]` lines → `db:migrate` hard-fails. WORKAROUND used: `db:schema:load` (schema.rb is correct). Bulk fix blocked by safety guard; needs your go-ahead.
- **B8 (OPEN):** `db/seeds.rb` creates 19 users but ZERO stores/products/events/malls → FriendlyId show pages 302/404 on empty data. Not a code bug; seed is incomplete. Recommend seeding ≥1 store + event for demo realism.

Improvements proposed:
- I1: Add `schema:load` to a `bin/setup`-style bootstrap so a fresh clone boots without the migrate dance.
- I2: Pin `mysql2` version explicitly; document `DATABASE_HOST=db` for compose.

## PERSONA 2 — Frontend / UX Engineer
**Verdict: CONDITIONAL — renders, but public browsing is broken for guests.**

Issues:
- **F1 (BLOCKER for public use):** Guests hitting `/events`, `/news`, `/music` get 302→`/` (see Security persona B9). Homepage links to these but they're login-gated. Contradicts a content platform's purpose.
- **F2:** `/music` previously 500'd (nil `@albums` + `track`/`album` var swap in view). FIXED in `tracks_controller#music` + `music.html.erb`.
- **F3:** Empty-state UX: store/product/event pages with no seed data show bare 404/redirect, no "no content yet" message.

Improvements:
- I3: Public `index`/`show` for `events`, `tracks`, `albums`, `galleries`, `features` should render WITHOUT auth (content is public). Fix in §Security B9.
- I4: Add friendly empty states.

## PERSONA 3 — Security Engineer
**Verdict: BLOCKER — authorization model over-broad AND under-broad.**

Issues:
- **B9 (HIGH, OPEN):** `app/controllers/concerns/role_based_access.rb:4-7` — `included do before_action :authenticate_user!; before_action :check_backstage_access end` applies to ALL 12 including controllers (events, tracks, albums, galleries, features, ads, ad_spots, users, profiles, main_banners, impersonations, dashboards). NO `except:`. Result: public `index`/`show` require login + `can_access_backend?`. This is both a UX bug (F1) and an auth-design smell — content controllers should not inherit a backstage gate by default.
- **B10 (MEDIUM):** `check_backstage_access` redirects to `root_path` on failure but `authenticate_user!` already handles unauthed → double gate. For public actions, the concern should not be included at all.
- **B11 (MEDIUM):** `DEMO_PASSWORD = "password123"` hardcoded in `db/seeds.rb:8` and committed. Acceptable for dev/demo, but must NOT ship to prod. Flag for env-var injection.
- **B12 (LOW):** `SECRET_KEY_BASE=dummy_dev_placeholder` passed at `docker compose up` runtime, not in `.env`. Fine for dev; ensure real secret in prod via secret manager.
- **B13 (LOW):** No `force_ssl` / no CSRF notes reviewed, but Devise + Rails defaults cover CSRF. OK.

Improvements:
- I5: Split the concern — a `BackendAccess` concern (with the `before_action` gate) for admin/backstage controllers, and let content controllers manage their own public `index`/`show` + per-action `require_*` for `edit`/`update`/`create`/`destroy`.
- I6: Move demo password to `ENV['DEMO_PASSWORD']` with fallback.

## PERSONA 4 — Database / Data Architect
**Verdict: CONDITIONAL — schema load-bearing but hand-patched.**

Issues:
- **B14 (OPEN):** `db/schema.rb` was edited by hand (bigint promote, artists table, main_banners timestamps, slug cols). It now DIVERGES from the 76 corrupted migrations. If someone runs `db:migrate` it will fail; if they run `db:schema:load` it works. Schema is the source of truth now — migrations are dead until cleaned (B7).
- **B15 (LOW):** `cell_number` stored as `integer` in `artists` (migration) — phone numbers overflow/lose leading zeros. Recommend `string`. (Improvement only; not changed to avoid migration churn.)
- **B16 (LOW):** `friendly_id_slugs` table present but `slug` history unused since slugs were missing — now populated going forward.

Improvements:
- I7: After cleaning migrations (B7), regenerate schema.rb from migrations to guarantee parity: `rails db:migrate:reset`.
- I8: Backfill NULL slugs for any existing rows via `Model.find_each(&:save!)` (none now, but defense-in-depth).

## PERSONA 5 — DevOps / Infra Engineer
**Verdict: CONDITIONAL — boots, but config has rough edges.**

Issues:
- **B17 (LOW):** `docker-compose.yml` uses obsolete `version:` key (warning on up). Remove it.
- **B18 (LOW):** `Dockerfile.dev` had `bundle config --global frozen 1` → blocked lockfile update during the mysql2 add. Changed to `frozen 0`. For dev that's fine; prod image should stay frozen.
- **B19 (LOW):** `config/puma.rb` `preload_app!` only in production block — correct. Dev reloads via Rails reloader. Good.
- **B20 (INFO):** DB exposed on host port 3307 (compose) to avoid clashing with local MariaDB 3306. Intentional, OK.

Improvements:
- I9: Drop `version:` from compose.
- I10: Document `docker compose up -d` boot sequence (db healthcheck before web).

## PERSONA 6 — Product / Domain Owner
**Verdict: CONDITIONAL — concept sound, demo data thin.**

Issues:
- **B21 (PRODUCT):** With 0 stores/products/events seeded, the "Red Village" marketplace/events value prop isn't demonstrable to a reviewer. Core differentiator (multi-role creator economy: DJ/artist/photographer/videographer/curator/designer/editor + storefront + ticketing) is wired but invisible without data.
- **B22 (PRODUCT):** Role dashboards exist for 9 roles but no obvious navigation linking anonymous visitors to "become a creator" / browse content.

Improvements:
- I11: Seed 1 mall, 2 stores, 3 products, 2 events, 1 gallery, a few tracks/albums so the app demonstrates end-to-end.
- I12: Add a public landing nav: Browse Events / Music / Gallery / Stores (public), Login/Sign-up (gated).

---

## Consolidated Issue Register
| ID | Persona | Severity | Status | Fix location |
|----|---------|----------|--------|--------------|
| B1 | BE | BLOCKER | FIXED | Gemfile/Gemfile.lock |
| B2 | BE | HIGH | FIXED | config/database.yml |
| B3 | BE | HIGH | FIXED | db/schema.rb (bigint) |
| B4 | BE | HIGH | FIXED | db/schema.rb + DDL (artists) |
| B5 | BE | HIGH | FIXED | db/schema.rb + DDL (main_banners ts) |
| B6 | BE | HIGH | FIXED | db/schema.rb + DDL (slug) |
| B7 | BE | MED | OPEN (consent) | db/migrate/* (76 dup-class) |
| B8 | BE | LOW | OPEN | db/seeds.rb (no stores/events) |
| F1 | FE | BLOCKER | see B9 | role_based_access.rb |
| F2 | FE | HIGH | FIXED | tracks_controller/music.html.erb |
| F3 | FE | LOW | OPEN | empty states |
| B9 | SEC | HIGH | OPEN | role_based_access.rb:4-7 |
| B10 | SEC | MED | OPEN | role_based_access.rb |
| B11 | SEC | MED | OPEN | db/seeds.rb:8 |
| B12 | SEC | LOW | OK(dev) | compose up |
| B14 | DBA | MED | OPEN | schema.rb vs migrations drift |
| B15 | DBA | LOW | IMPR | artists.cell_number type |
| B17 | OPS | LOW | OPEN | docker-compose.yml version |
| B18 | OPS | LOW | FIXED | Dockerfile.dev frozen 0 |
| B21 | PROD | MED | OPEN | seed/demo data |
| B22 | PROD | LOW | OPEN | public nav |

## Improvements Delivered (already applied)
- App boots end-to-end (was non-functional).
- All 9 role dashboards render (was 404/500).
- `/music`, `/designer/dashboard`, store/product/mall routes no longer 500.
- DB schema corrected (bigint FKs, missing artists table, main_banners timestamps, FriendlyId slug cols).

## Improvements Proposed (pending your decision)
- I5/I6 (Security): split RoleBasedAccess so content is public; demo password via ENV.
- I3/I4 (FE): public index/show + empty states.
- B7 (BE): bulk-fix 76 migrations (needs your consent — safety guard).
- B8/I11 (Product): seed demo stores/events so the platform is demonstrable.
- I9 (Ops): drop obsolete compose `version:`.

## Open Decisions Required From You
1. **Approve bulk fix of 76 corrupted migration files** (git-reversible)? Enables `db:migrate` parity with schema.
2. **Make events/news/music/store browsing PUBLIC** (recommended) vs keep login-gated?
3. **Seed demo content** (store/event/product) for a realistic review?
4. **Commit the current working state** (boot fixes + schema) to git now, or wait until decisions 1–3 land?

**Overall board verdict: CONDITIONAL APPROVE.** The app RUNS and all authenticated + admin flows are green. Three blockers remain for *public* usability (B9/F1 auth gate, B8/B21 empty seed data, B7 migration drift) — none prevent running, all are fixable in one more pass with your sign-off on the two consent items (migrations bulk-edit, public-vs-gated decision).
